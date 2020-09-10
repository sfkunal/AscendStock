//
//  ATCLoginScreenProtocol.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/8/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

protocol ATCLandingScreenDelegate: class {
    func landingScreenDidLoadView(_ landingScreen: ATCLandingScreenProtocol)
}

protocol ATCLoginScreenDelegate: class {
    func loginScreenDidLoadView(_ loginScreen: ATCLoginScreenProtocol)
}

protocol ATCSignUpScreenDelegate: class {
    func signUpScreenDidLoadView(_ signUpScreen: ATCSignUpScreenProtocol)
}

protocol ATCLandingScreenProtocol {
    var logoImageView: UIImageView! {get}
    var titleLabel: UILabel! {get}
    var subtitleLabel: UILabel! {get}
    var loginButton: UIButton! {get}
    var signUpButton: UIButton! {get}
    var delegate: ATCLandingScreenDelegate? {get set}
}

protocol ATCLoginScreenProtocol {
    var titleLabel: UILabel! {get}
    var contactPointTextField: ATCTextField! {get}
    var passwordTextField: ATCTextField! {get}
    var separatorLabel: UILabel! {get}
    var loginButton: UIButton! {get}
    var facebookButton: UIButton! {get}
    func display(alertController: UIAlertController)
}

protocol ATCSignUpScreenProtocol {
    var titleLabel: UILabel! {get}
    var backButton: UIButton! {get}
    var nameTextField: ATCTextField! {get}
    var phoneNumberTextField: ATCTextField! {get}
    var emailTextField: ATCTextField! {get}
    var passwordTextField: ATCTextField! {get}
    var errorLabel: UILabel! {get}
    var signUpButton: UIButton! {get}
    func display(alertController: UIAlertController)
}
