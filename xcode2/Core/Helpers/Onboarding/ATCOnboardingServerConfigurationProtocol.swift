//
//  ATCOnboardingServerConfigurationProtocol.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/18/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

protocol ATCOnboardingServerConfigurationProtocol {
    var isFirebaseAuthEnabled: Bool {get}
    var appIdentifier: String {get}
}
