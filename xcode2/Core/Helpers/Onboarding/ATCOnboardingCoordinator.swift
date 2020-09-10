//
//  ATCOnboardingCoordinator.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/8/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

protocol ATCOnboardingCoordinatorDelegate: class {
    func coordinatorDidCompleteOnboarding(_ coordinator: ATCOnboardingCoordinatorProtocol, user: ATCUser?)
    func coordinatorDidResyncCredentials(_ coordinator: ATCOnboardingCoordinatorProtocol, user: ATCUser?)
}

protocol ATCOnboardingCoordinatorProtocol: ATCLandingScreenManagerDelegate {
    func viewController() -> UIViewController
    var delegate: ATCOnboardingCoordinatorDelegate? {get set}
    func resyncPersistentCredentials(user: ATCUser) -> Void
}

class ATCClassicOnboardingCoordinator: ATCOnboardingCoordinatorProtocol, ATCLoginScreenManagerDelegate, ATCSignUpScreenManagerDelegate {
    weak var delegate: ATCOnboardingCoordinatorDelegate?

    let landingManager: ATCLandingScreenManager
    let landingScreen: ATCClassicLandingScreenViewController

    let loginManager: ATCLoginScreenManager
    let loginScreen: ATCClassicLoginScreenViewController

    let signUpManager: ATCSignUpScreenManager
    let signUpScreen: ATCClassicSignUpViewController

    let navigationController: UINavigationController

    let serverConfig: ATCOnboardingServerConfigurationProtocol
    let firebaseLoginManager: ATCFirebaseLoginManager?

    init(landingViewModel: ATCLandingScreenViewModel,
         loginViewModel: ATCLoginScreenViewModel,
         signUpViewModel: ATCSignUpScreenViewModel,
         uiConfig: ATCOnboardingConfigurationProtocol,
         serverConfig: ATCOnboardingServerConfigurationProtocol,
         userManager: ATCSocialUserManagerProtocol?) {
        self.serverConfig = serverConfig
        self.firebaseLoginManager = serverConfig.isFirebaseAuthEnabled ? ATCFirebaseLoginManager() : nil
        self.landingScreen = ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil)
        self.landingManager = ATCLandingScreenManager(landingScreen: self.landingScreen, viewModel: landingViewModel, uiConfig: uiConfig)
        self.landingScreen.delegate = landingManager

        self.loginScreen = ATCClassicLoginScreenViewController(nibName: "ATCClassicLoginScreenViewController", bundle: nil)
        self.loginManager = ATCLoginScreenManager(loginScreen: self.loginScreen,
                                                  viewModel: loginViewModel,
                                                  uiConfig: uiConfig,
                                                  serverConfig: serverConfig,
                                                  userManager: userManager)
        self.loginScreen.delegate = loginManager

        self.signUpScreen = ATCClassicSignUpViewController(nibName: "ATCClassicSignUpViewController", bundle: nil)
        self.signUpManager = ATCSignUpScreenManager(signUpScreen: self.signUpScreen, viewModel: signUpViewModel, uiConfig: uiConfig, serverConfig: serverConfig)
        self.signUpScreen.delegate = signUpManager

        self.navigationController = UINavigationController(rootViewController: landingScreen)

        self.landingManager.delegate = self
        self.loginManager.delegate = self
        self.signUpManager.delegate = self
    }

    func viewController() -> UIViewController {
        return navigationController
    }

    func resyncPersistentCredentials(user: ATCUser) -> Void {
        if serverConfig.isFirebaseAuthEnabled {
            self.firebaseLoginManager?.resyncPersistentUser(user: user) {[weak self] (syncedUser) in
                guard let `self` = self else { return }
                self.delegate?.coordinatorDidResyncCredentials(self, user: syncedUser)
            }
        } else {
            self.delegate?.coordinatorDidResyncCredentials(self, user: user)
        }
    }

    func landingScreenManagerDidTapLogIn(manager: ATCLandingScreenManager) {
        self.navigationController.pushViewController(self.loginScreen, animated: true)
    }

    func landingScreenManagerDidTapSignUp(manager: ATCLandingScreenManager) {
        self.navigationController.pushViewController(self.signUpScreen, animated: true)
    }

    func loginManagerDidCompleteLogin(_ loginManager: ATCLoginScreenManager, user: ATCUser?) {
        self.delegate?.coordinatorDidCompleteOnboarding(self, user: user)
    }

    func signUpManagerDidCompleteSignUp(_ signUpManager: ATCSignUpScreenManager, user: ATCUser?) {
        self.delegate?.coordinatorDidCompleteOnboarding(self, user: user)
    }
}
