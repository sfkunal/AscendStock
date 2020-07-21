//
//  ATCLoginScreenManager.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/8/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import UIKit

protocol ATCLoginScreenManagerDelegate: class {
    func loginManagerDidCompleteLogin(_ loginManager: ATCLoginScreenManager, user: ATCUser?)
}

class ATCLoginScreenManager: ATCLoginScreenDelegate {
    let loginScreen: ATCLoginScreenProtocol
    let viewModel: ATCLoginScreenViewModel
    let uiConfig: ATCOnboardingConfigurationProtocol
    let serverConfig: ATCOnboardingServerConfigurationProtocol
    let userManager: ATCSocialUserManagerProtocol?
    let loginManager: ATCFirebaseLoginManager

    weak var delegate: ATCLoginScreenManagerDelegate?

    private let readPermissions: [String] = ["public_profile",
                                             "email",
                                             "user_friends",
                                             "user_posts"]

    init(loginScreen: ATCLoginScreenProtocol,
         viewModel: ATCLoginScreenViewModel,
         uiConfig: ATCOnboardingConfigurationProtocol,
         serverConfig: ATCOnboardingServerConfigurationProtocol,
         userManager: ATCSocialUserManagerProtocol?) {
        self.loginScreen = loginScreen
        self.viewModel = viewModel
        self.uiConfig = uiConfig
        self.serverConfig = serverConfig
        self.userManager = userManager
        self.loginManager = ATCFirebaseLoginManager()
    }

    func loginScreenDidLoadView(_ loginScreen: ATCLoginScreenProtocol) {
        if let titleLabel = loginScreen.titleLabel {
            titleLabel.font = uiConfig.titleFont
            titleLabel.text = viewModel.title
            titleLabel.textColor = uiConfig.titleColor
        }

        if let cpField = loginScreen.contactPointTextField {
            cpField.configure(color: uiConfig.textFieldColor,
                              font: uiConfig.textFieldFont,
                              cornerRadius: 55/2,
                              borderColor: uiConfig.textFieldBorderColor,
                              backgroundColor: uiConfig.textFieldBackgroundColor,
                              borderWidth: 1.0)
            cpField.placeholder = viewModel.contactPointField
            cpField.textContentType = .emailAddress
            cpField.clipsToBounds = true
        }

        if let passwordField = loginScreen.passwordTextField {
            passwordField.configure(color: uiConfig.textFieldColor,
                                    font: uiConfig.textFieldFont,
                                    cornerRadius: 55/2,
                                    borderColor: uiConfig.textFieldBorderColor,
                                    backgroundColor: uiConfig.textFieldBackgroundColor,
                                    borderWidth: 1.0)
            passwordField.placeholder = viewModel.passwordField
            passwordField.isSecureTextEntry = true
            passwordField.textContentType = .emailAddress
            passwordField.clipsToBounds = true
        }

        if let separatorLabel = loginScreen.separatorLabel {
            separatorLabel.font = uiConfig.separatorFont
            separatorLabel.textColor = uiConfig.separatorColor
            separatorLabel.text = viewModel.separatorString
        }

        if let loginButton = loginScreen.loginButton {
            loginButton.setTitle(viewModel.loginString, for: .normal)
            loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
            loginButton.configure(color: uiConfig.loginButtonTextColor,
                                  font: uiConfig.loginButtonFont,
                                  cornerRadius: 55/2,
                                  backgroundColor: uiConfig.loginButtonBackgroundColor)
        }

        if let facebookButton = loginScreen.facebookButton {
            facebookButton.setTitle(viewModel.facebookString, for: .normal)
            facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
            facebookButton.configure(color: uiConfig.loginButtonTextColor,
                                     font: uiConfig.loginButtonFont,
                                     cornerRadius: 55/2,
                                     backgroundColor: UIColor(hexString: "#334D92"))
        }
    }

    @objc func didTapLoginButton() {
        if serverConfig.isFirebaseAuthEnabled {
            if let email = loginScreen.contactPointTextField.text, let password = loginScreen.passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) {[weak self] (dataResult, error) in
                    if let strongSelf = self, let user = dataResult?.user {
                        let atcUser = ATCUser(uid: user.uid,
                                              firstName: user.displayName ?? "",
                                              lastName: "",
                                              avatarURL: user.photoURL?.absoluteString ?? "",
                                              email: user.email ?? "")
                        strongSelf.userManager?.fetchUser(userID: user.uid, completion: {[weak strongSelf] (user) in
                            if let secondStrongSelf = strongSelf {
                                secondStrongSelf.delegate?.loginManagerDidCompleteLogin(secondStrongSelf, user: user ?? atcUser)
                            }
                        })
                    } else {
                        self?.showLoginError()
                    }
                }
            } else {
                self.showLoginError()
            }
            return
        }
        self.delegate?.loginManagerDidCompleteLogin(self, user: nil)
    }

    @objc func didTapFacebookButton() {
        if let loginScreen = loginScreen as? UIViewController {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: readPermissions, from: loginScreen) { (result, error) in
                if (result?.token != nil) {
                    self.didLoginWithFacebook()
                }
            }
        }
    }

    private func didLoginWithFacebook() {
        //  Successful log in with Facebook
        if let accessToken = AccessToken.current {
            // If Firebase enabled, we log the user into Firebase
            if serverConfig.isFirebaseAuthEnabled {
                ATCFirebaseLoginManager.login(credential: FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)) {[weak self] (atcUser) in
                    if let user = atcUser, let strongSelf = self {
                        strongSelf.loginManager.saveUserToServerIfNeeded(user: user, appIdentifier: strongSelf.serverConfig.appIdentifier)
                        strongSelf.delegate?.loginManagerDidCompleteLogin(strongSelf, user: user)
                    } else {
                        // Facebook succeeded, but Firebase failed
                        self?.showLoginError()
                    }
                }
            } else {
                let facebookAPIManager = ATCFacebookAPIManager(accessToken: accessToken)
                facebookAPIManager.requestFacebookUser(completion: {[weak self] (facebookUser) in
                    if let strongSelf = self, let email = facebookUser?.email {
                        let atcUser = ATCUser(uid: facebookUser?.id ?? "",
                                              firstName: facebookUser?.firstName ?? "",
                                              lastName: facebookUser?.lastName ?? "",
                                              avatarURL: facebookUser?.profilePicture ?? "",
                                              email: email)
                        strongSelf.delegate?.loginManagerDidCompleteLogin(strongSelf, user: atcUser)
                    } else {
                        self?.showLoginError()
                    }
                })
            }
            return
        }
        self.showLoginError()
    }

    fileprivate func showLoginError() {
        let alert = UIAlertController(title: "The login credentials are invalid. Please try again", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.loginScreen.display(alertController: alert)
    }
}
