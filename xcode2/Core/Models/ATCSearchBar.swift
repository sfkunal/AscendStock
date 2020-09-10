//
//  ATCSearchBar.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/21/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCSearchBar: ATCGenericBaseModel {
    var placeholder: String

    init(placeholder: String) {
        self.placeholder = placeholder
    }
    required init(jsonDict: [String: Any]) {
        fatalError()
    }
    var description: String {
        return "searchbar"
    }
}
