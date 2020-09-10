//
//  ATCFinanceInstitution.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/25/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceInstitution: ATCGenericBaseModel {
    var title: String
    var imageUrl: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String, imageUrl: String) {
        self.title = title
        self.imageUrl = imageUrl
    }

    var description: String {
        return title
    }
}
