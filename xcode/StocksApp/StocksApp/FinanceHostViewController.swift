

import UIKit

class FinanceHostViewController: UIViewController, UITabBarControllerDelegate {

    let uiConfig: FinanceUIConfiguration
    let serverConfig: ATCOnboardingServerConfigurationProtocol

    let homeVC: StocksHomeViewController
    let portfolioVC: PortfolioViewController
    let bankAccountsVC: BankAccountsViewController
    let newsVC: NewsViewController
    let notificationsVC: FinanceNotificationsViewController
    var profileVC: ATCProfileViewController?
    let dsProvider: ATCFinanceDataSourceProviderProtocol

    init(uiConfig: FinanceUIConfiguration,
         serverConfig: ATCOnboardingServerConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.serverConfig = serverConfig
        self.dsProvider = dsProvider

        self.homeVC = StocksHomeViewController(uiConfig: uiConfig, dsProvider: dsProvider)
        self.portfolioVC = PortfolioViewController(uiConfig: uiConfig, dsProvider: dsProvider)
        self.bankAccountsVC = BankAccountsViewController(uiConfig: uiConfig, dsProvider: dsProvider)
        self.newsVC = NewsViewController(dsProvider: dsProvider, uiConfig: uiConfig)
        self.notificationsVC = FinanceNotificationsViewController(dsProvider: dsProvider, uiConfig: uiConfig)

        super.init(nibName: nil, bundle: nil)
        self.profileVC = self.profileViewController()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var hostController: ATCHostViewController = { [unowned self] in
        guard let profileVC = profileVC else {
            fatalError()
        }
        let menuItems: [ATCNavigationItem] = [
            ATCNavigationItem(title: "Home",
                              viewController: homeVC,
                              image: uiConfig.homeImage,
                              type: .viewController,
                              leftTopViews: nil,
                              rightTopViews: nil),
            ATCNavigationItem(title: "Portfolio",
                              viewController: portfolioVC,
                              image: uiConfig.portfolioImage,
                              type: .viewController),
            ATCNavigationItem(title: "Accounts",
                              viewController: bankAccountsVC,
                              image: uiConfig.accountsImage,
                              type: .viewController),
            ATCNavigationItem(title: "News",
                              viewController: newsVC,
                              image: uiConfig.newsImage,
                              type: .viewController),
            ATCNavigationItem(title: "Notifications",
                              viewController: notificationsVC,
                              image: uiConfig.notificationsImage,
                              type: .viewController),
            ATCNavigationItem(title: "Profile",
                              viewController: profileVC,
                              image: uiConfig.profileImage,
                              type: .viewController)
        ]
        let menuConfiguration = ATCMenuConfiguration(user: nil,
                                                     cellClass: ATCCircledIconMenuCollectionViewCell.self,
                                                     headerHeight: 0,
                                                     items: menuItems,
                                                     uiConfig: ATCMenuUIConfiguration(itemFont: uiConfig.regularMediumFont,
                                                                                      tintColor: uiConfig.mainTextColor,
                                                                                      itemHeight: 45.0,
                                                                                      backgroundColor: uiConfig.mainThemeBackgroundColor))

        let config = ATCHostConfiguration(menuConfiguration: menuConfiguration,
                                          style: .tabBar,
                                          topNavigationRightViews: nil,
                                          titleView: nil,
                                          topNavigationLeftImage: UIImage.localImage("three-equal-lines-icon", template: true),
                                          topNavigationTintColor: uiConfig.mainThemeForegroundColor,
                                          statusBarStyle: uiConfig.statusBarStyle,
                                          uiConfig: uiConfig,
                                          pushNotificationsEnabled: true,
                                          locationUpdatesEnabled: false)
        let onboardingCoordinator = self.onboardingCoordinator(uiConfig: uiConfig, serverConfig: serverConfig)
        let walkthroughVC = self.walkthroughVC(uiConfig: uiConfig)
        let vc = ATCHostViewController(configuration: config, onboardingCoordinator: onboardingCoordinator, walkthroughVC: walkthroughVC, profilePresenter: nil)
        vc.delegate = self
        return vc
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewControllerWithView(hostController)
        hostController.view.backgroundColor = uiConfig.mainThemeBackgroundColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return uiConfig.statusBarStyle
    }

    fileprivate func onboardingCoordinator(uiConfig: FinanceUIConfiguration, serverConfig: ATCOnboardingServerConfigurationProtocol) -> ATCOnboardingCoordinatorProtocol {
        let landingViewModel = ATCLandingScreenViewModel(imageIcon: "finance-app-icon-1",
                                                         title: "Welcome to Stocks App",
                                                         subtitle: "Exchange, trade and monitor stocks.",
                                                         loginString: "Log In",
                                                         signUpString: "Sign Up")
        let loginViewModel = ATCLoginScreenViewModel(contactPointField: "E-mail or phone number",
                                                     passwordField: "Password",
                                                     title: "Sign In",
                                                     loginString: "Log In",
                                                     facebookString: "Facebook Login",
                                                     separatorString: "OR")

        let signUpViewModel = ATCSignUpScreenViewModel(nameField: "Full Name",
                                                       phoneField: "Phone Number",
                                                       emailField: "E-mail Address",
                                                       passwordField: "Password",
                                                       title: "Create new account",
                                                       signUpString: "Sign Up")
        let userManager: ATCSocialUserManagerProtocol? = serverConfig.isFirebaseAuthEnabled ? ATCSocialFirebaseUserManager() : nil
        return ATCClassicOnboardingCoordinator(landingViewModel: landingViewModel,
                                               loginViewModel: loginViewModel,
                                               signUpViewModel: signUpViewModel,
                                               uiConfig: FinanceOnboardingConfiguration(config: uiConfig),
                                               serverConfig: serverConfig,
                                               userManager: userManager)
    }

    fileprivate func walkthroughVC(uiConfig: FinanceUIConfiguration) -> ATCWalkthroughViewController {
        let viewControllers = FinanceStaticDataProvider.walkthroughs.map { ATCClassicWalkthroughViewController(model: $0, uiConfig: uiConfig, nibName: "ATCClassicWalkthroughViewController", bundle: nil) }
        return ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                            bundle: nil,
                                            viewControllers: viewControllers,
                                            uiConfig: uiConfig)
    }

    fileprivate func profileViewController() -> ATCProfileViewController {
        let vc = ATCProfileViewController(items: self.selfProfileItems(),
                                          uiConfig: uiConfig,
                                          selectionBlock: {[weak self] (nav, model, index) in
                                            guard let `self` = self else { return }
                                            if let _ = model as? ATCProfileButtonItem {
                                                // Logout
                                                NotificationCenter.default.post(name: kLogoutNotificationName, object: nil)
                                            } else if let item = model as? ATCProfileItem {
                                                if item.title == "Settings", let user = self.dsProvider.user {
                                                    let settingsVC = SettingsViewController(user: user)
                                                    self.profileVC?.navigationController?.pushViewController(settingsVC, animated: true)
                                                } else if item.title == "Account Details", let user = self.dsProvider.user  {
                                                    let accountSettingsVC = FinanceAccountDetailsViewController(user: user, updater: self.dsProvider.profileUpdater)
                                                    self.profileVC?.navigationController?.pushViewController(accountSettingsVC, animated: true)
                                                } else {
                                                    let contactVC = ATCFinanceContactUsViewController()
                                                    nav?.pushViewController(contactVC, animated: true)
                                                }
                                            }
            }
        )
        vc.title = "Profile"
        return vc
    }

    fileprivate func selfProfileItems() -> [ATCGenericBaseModel] {
        var items: [ATCGenericBaseModel] = []
        items.append(contentsOf: [ATCProfileItem(icon: UIImage.localImage("account-male-icon", template: true),
                                                 title: "Account Details",
                                                 type: .arrow,
                                                 color: UIColor(hexString: "#00ff99")),
                                  ATCProfileItem(icon: UIImage.localImage("settings-menu-item", template: true),
                                                 title: "Settings",
                                                 type: .arrow,
                                                 color: UIColor(hexString: "#00ff99")),
                                  ATCProfileItem(icon: UIImage.localImage("contact-call-icon", template: true),
                                                 title: "Contact Us",
                                                 type: .arrow,
                                                 color: UIColor(hexString: "#64E790"))
            ]);
        return items
    }
}

extension FinanceHostViewController: ATCHostViewControllerDelegate {
    func hostViewController(_ hostViewController: ATCHostViewController, didLogin user: ATCUser) {
        self.dsProvider.user = user
        self.profileVC?.user = user
    }

    func hostViewController(_ hostViewController: ATCHostViewController, didSync user: ATCUser) {
        self.dsProvider.user = user
        self.profileVC?.user = user
    }
}
