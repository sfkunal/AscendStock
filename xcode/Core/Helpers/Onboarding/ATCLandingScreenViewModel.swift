//
//  ATCLoginScreenViewModel.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/8/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import Foundation

struct ATCLandingScreenViewModel {
    let imageIcon: String
    let title: String
    let subtitle: String
    let loginString: String
    let signUpString: String
}

struct ATCLoginScreenViewModel {
    let contactPointField: String
    let passwordField: String
    let title: String
    let loginString: String
    let facebookString: String
    let separatorString: String
}

struct ATCSignUpScreenViewModel {
    let nameField: String
    let phoneField: String
    let emailField: String
    let passwordField: String
    let title: String
    let signUpString: String
}
