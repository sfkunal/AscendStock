//
//  ATCNavigationViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/8/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//
import LocalAuthentication
import UIKit

let kLogoutNotificationName = NSNotification.Name(rawValue: "kLogoutNotificationName")

public enum ATCNavigationStyle {
    case tabBar
    case sideBar
}

public enum ATCNavigationMenuItemType {
    case viewController
    case logout
}

public final class ATCNavigationItem: ATCGenericBaseModel {
    let viewController: UIViewController
    let title: String?
    let image: UIImage?
    let selectedImage: UIImage?
    let type: ATCNavigationMenuItemType
    let leftTopViews: [UIView]? 
    let rightTopViews: [UIView]?

    init(title: String?,
         viewController: UIViewController,
         image: UIImage?,
         selectedImage: UIImage? = nil,
         type: ATCNavigationMenuItemType,
         leftTopViews: [UIView]? = nil,
         rightTopViews: [UIView]? = nil) {
        self.title = title
        self.viewController = viewController
        self.image = image
        self.type = type
        self.selectedImage = selectedImage
        self.leftTopViews = leftTopViews
        self.rightTopViews = rightTopViews
    }

    convenience init(jsonDict: [String: Any]) {
        self.init(title: "", viewController: UIViewController(), image: nil, type: .viewController)
    }

    public var description: String {
        return title ?? "no description"
    }
}

public struct ATCHostConfiguration {
    let menuConfiguration: ATCMenuConfiguration
    let style: ATCNavigationStyle
    let topNavigationRightViews: [UIView]?
    let titleView: UIView?
    let topNavigationLeftImage: UIImage?
    let topNavigationTintColor: UIColor?
    let statusBarStyle: UIStatusBarStyle
    let uiConfig: ATCUIGenericConfigurationProtocol
    let pushNotificationsEnabled: Bool
    let locationUpdatesEnabled: Bool
}

public protocol ATCHostViewControllerDelegate: class {
    func hostViewController(_ hostViewController: ATCHostViewController, didLogin user: ATCUser)
    func hostViewController(_ hostViewController: ATCHostViewController, didSync user: ATCUser)
}

public class ATCHostViewController: UIViewController, ATCOnboardingCoordinatorDelegate, ATCWalkthroughViewControllerDelegate {
    var user: ATCUser? {
        didSet {
            menuViewController?.user = user
            menuViewController?.collectionView?.reloadData()
            self.updateNavigationProfilePhotoIfNeeded()
        }
    }

    var items: [ATCNavigationItem] {
        didSet {
            menuViewController?.genericDataSource = ATCGenericLocalDataSource(items: items)
            menuViewController?.collectionView?.reloadData()
        }
    }
    let style: ATCNavigationStyle
    let statusBarStyle: UIStatusBarStyle

    var tabController: UITabBarController?
    var navigationRootController: ATCNavigationController?
    var menuViewController: ATCMenuCollectionViewController?
    var drawerController: ATCDrawerController?
    var onboardingCoordinator: ATCOnboardingCoordinatorProtocol?
    var walkthroughVC: ATCWalkthroughViewController?
    var profilePresenter: ATCProfileScreenPresenterProtocol?
    var pushNotificationsEnabled: Bool
    var locationUpdatesEnabled: Bool
    var pushManager: ATCPushNotificationManager?
    var locationManager: ATCLocationManager?
    var profileUpdater: ATCProfileUpdaterProtocol?

    weak var delegate: ATCHostViewControllerDelegate?

    init(configuration: ATCHostConfiguration,
         onboardingCoordinator: ATCOnboardingCoordinatorProtocol?,
         walkthroughVC: ATCWalkthroughViewController?,
         profilePresenter: ATCProfileScreenPresenterProtocol? = nil,
         profileUpdater: ATCProfileUpdaterProtocol? = nil) {
        self.style = configuration.style
        self.onboardingCoordinator = onboardingCoordinator
        self.walkthroughVC = walkthroughVC
        self.profileUpdater = profileUpdater
        let menuConfiguration = configuration.menuConfiguration
        self.items = menuConfiguration.items
        self.user = menuConfiguration.user
        self.statusBarStyle = configuration.statusBarStyle
        self.profilePresenter = profilePresenter
        self.pushNotificationsEnabled = configuration.pushNotificationsEnabled
        self.locationUpdatesEnabled = configuration.locationUpdatesEnabled

        super.init(nibName: nil, bundle: nil)
        configureChildrenViewControllers(configuration: configuration)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didRequestLogout), name: kLogoutNotificationName, object: nil)
        let store = ATCPersistentStore()
        var userStatus: Bool = false
        let faceIDKey = "face_id_enabled"
        
        if let loggedInUser = store.userIfLoggedInUser() {
            let result = UserDefaults.standard.value(forKey: "\(loggedInUser.uid!)")
          
            if let finalResult = result as? [String : Bool] {
                userStatus = finalResult[faceIDKey] ?? false
            }
            
            if userStatus {
                self.biometricauthentication(user: loggedInUser)
            } else {
                onboardingCoordinator?.delegate = self
                self.onboardingCoordinator?.resyncPersistentCredentials(user: loggedInUser)
            }
            return
        }
    
        if let walkthroughVC = walkthroughVC, !store.isWalkthroughCompleted() {
            walkthroughVC.delegate = self
            self.addChildViewControllerWithView(walkthroughVC)
        } else if let onboardingCoordinator = onboardingCoordinator {
            onboardingCoordinator.delegate = self
            self.addChildViewControllerWithView(onboardingCoordinator.viewController())
        } else {
            presentLoggedInViewControllers()
        }
    }
    
    private func biometricauthentication(user: ATCUser) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        print("Successfully match")
                        self.onboardingCoordinator?.delegate = self
                        self.onboardingCoordinator?.resyncPersistentCredentials(user: user)
                    }else {
                        print("Error - not a successful match - Log in using password")
                        if let onboardingCoordinator = self.onboardingCoordinator {
                            onboardingCoordinator.delegate = self
                            self.addChildViewControllerWithView(onboardingCoordinator.viewController())
                        }
                    }
                }
            }
        } else {
            print("No Biometric Auth support")
        }
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let walkthroughVC = walkthroughVC {
            walkthroughVC.view.frame = self.view.bounds
            walkthroughVC.view.setNeedsLayout()
            walkthroughVC.view.layoutIfNeeded()
        }
    }

    @objc fileprivate func didRequestLogout() {
        let store = ATCPersistentStore()
        store.logout()
        if let onboardingCoordinator = onboardingCoordinator {
            let childVC: UIViewController = (style == .tabBar) ? tabController! : drawerController!
            childVC.removeFromParent()
            childVC.view.removeFromSuperview()

            onboardingCoordinator.delegate = self
            self.addChildViewControllerWithView(onboardingCoordinator.viewController())
        }
    }

    fileprivate func presentLoggedInViewControllers() {
        self.onboardingCoordinator?.viewController().removeFromParent()
        self.onboardingCoordinator?.viewController().view.removeFromSuperview()
        let childVC: UIViewController = (style == .tabBar) ? tabController! : drawerController!
        if ((style == .tabBar) ? tabController!.view : drawerController!.view) != nil {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.addChildViewControllerWithView(childVC)
            }, completion: {(finished) in
                if let user = self.user {
                    self.pushManager = ATCPushNotificationManager(user: user)
                    self.pushManager?.registerForPushNotifications()
                }
            })
        }
    }

    fileprivate func updateNavigationProfilePhotoIfNeeded() {
        if (self.style == .tabBar && profilePresenter != nil) {
            if let firstNavigationVC = self.tabController?.children.first as? ATCNavigationController {
                let uiControl = UIControl(frame: .zero)
                uiControl.snp.makeConstraints { (maker) in
                    maker.height.equalTo(30)
                    maker.width.equalTo(30)
                }
                uiControl.addTarget(self, action: #selector(didTapProfilePhotoControl), for: .touchUpInside)

                let imageView = UIImageView(image: nil)
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 30.0/2.0
                uiControl.addSubview(imageView)
                imageView.snp.makeConstraints { (maker) in
                    maker.left.equalTo(uiControl)
                    maker.right.equalTo(uiControl)
                    maker.bottom.equalTo(uiControl.snp.bottom)
                    maker.top.equalTo(uiControl)
                }
                imageView.backgroundColor = UIColor(hexString: "#343d52")
                if let url = user?.profilePictureURL {
                    imageView.kf.setImage(with: URL(string: url))
                }
                firstNavigationVC.topNavigationLeftViews = [uiControl]
                firstNavigationVC.prepareNavigationBar()
                firstNavigationVC.view.setNeedsLayout()
            }
        }
    }

    @objc fileprivate func didTapProfilePhotoControl() {
        if let profilePresenter = profilePresenter, let user = user {
            profilePresenter.presentProfileScreen(viewController: self, user: user)
        }
    }

    fileprivate func configureChildrenViewControllers(configuration: ATCHostConfiguration) {
        if (style == .tabBar) {
            let navigationControllers = items.filter{$0.type == .viewController}.map {
                ATCNavigationController(rootViewController: $0.viewController,
                                        topNavigationLeftViews: $0.leftTopViews,
                                        topNavigationRightViews: ($0.rightTopViews?.count ?? 0) == 0 ? configuration.topNavigationRightViews : $0.rightTopViews,
                                        topNavigationLeftImage: nil)
            }
            tabController = UITabBarController()
            tabController?.setViewControllers(navigationControllers, animated: true)
            for (tag, item) in items.enumerated() {
                let tabBarItem = UITabBarItem(title: item.title, image: item.image, tag: tag)
                if let selectedImage = item.selectedImage {
                    tabBarItem.selectedImage = selectedImage
                }
                if item.title == nil {
                    tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
                }
                item.viewController.tabBarItem = tabBarItem
            }
        } else {
            guard let firstVC = items.first?.viewController else { return }
            navigationRootController = ATCNavigationController(rootViewController: firstVC,
                                                               topNavigationRightViews: configuration.topNavigationRightViews,
                                                               titleView: configuration.titleView,
                                                               topNavigationLeftImage: configuration.topNavigationLeftImage,
                                                               topNavigationTintColor: configuration.topNavigationTintColor)
            let collectionVCConfiguration = ATCGenericCollectionViewControllerConfiguration(
                pullToRefreshEnabled: false,
                pullToRefreshTintColor: .white,
                collectionViewBackgroundColor: .black,
                collectionViewLayout: ATCLiquidCollectionViewLayout(),
                collectionPagingEnabled: false,
                hideScrollIndicators: false,
                hidesNavigationBar: false,
                headerNibName: nil,
                scrollEnabled: true,
                uiConfig: configuration.uiConfig
            )
            let menuConfiguration = configuration.menuConfiguration
            menuViewController = ATCMenuCollectionViewController(menuConfiguration: menuConfiguration, collectionVCConfiguration: collectionVCConfiguration)
            menuViewController?.genericDataSource = ATCGenericLocalDataSource<ATCNavigationItem>(items: menuConfiguration.items)
            drawerController = ATCDrawerController(rootViewController: navigationRootController!, menuController: menuViewController!)
            navigationRootController?.drawerDelegate = drawerController
            if let drawerController = drawerController {
                self.addChild(drawerController)
                navigationRootController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
                navigationRootController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
            }
        }
    }

    func coordinatorDidCompleteOnboarding(_ coordinator: ATCOnboardingCoordinatorProtocol, user: ATCUser?) {
        self.didFetchUser(user)
    }

    func coordinatorDidResyncCredentials(_ coordinator: ATCOnboardingCoordinatorProtocol, user: ATCUser?) {
        self.didFetchUser(user)
    }

    func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
        let store = ATCPersistentStore()
        store.markWalkthroughCompleted()

        if let onboardingCoordinator = self.onboardingCoordinator {
            onboardingCoordinator.delegate = self
            UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
                self.walkthroughVC?.view.removeFromSuperview()
                self.view.addSubview(onboardingCoordinator.viewController().view)
            }, completion: nil)
        } else {
            self.presentLoggedInViewControllers()
        }
    }

    fileprivate func didFetchUser(_ user: ATCUser?) {
        self.user = user
        presentLoggedInViewControllers()
        if let user = user {
            let store = ATCPersistentStore()
            store.markUserAsLoggedIn(user: user)
            self.delegate?.hostViewController(self, didSync: user)
        }
        if locationUpdatesEnabled {
            locationManager = ATCLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUsePermission()
        }
    }
}

extension ATCHostViewController: ATCLocationManagerDelegate {
    func locationManager(_ locationManager: ATCLocationManager, didReceive location: ATCLocation) {
        guard let profileUpdater = profileUpdater else {
            fatalError("You specified continuous location updates, but did not create a profile updater object to actually update the location in the database")
        }
        guard let user = user else { return }
        profileUpdater.updateLocation(for: user, to: location) { (success) in
        }
    }
}
