//
//  ATCText.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

protocol ATCTextProtocol {
    var text: String {get}
    var accessoryText: String? {get}
}

class ATCText: ATCGenericBaseModel, ATCTextProtocol {

    var text: String
    var accessoryText: String?

    init(text: String, accessoryText: String? = nil) {
        self.text = text
        self.accessoryText = accessoryText
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    var description: String {
        return text
    }
}
