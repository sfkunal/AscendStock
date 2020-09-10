//
//  ATCExpenseCategory.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/18/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCExpenseCategory: ATCGenericBaseModel {
    var title: String
    var color: String
    var logoURL: String
    var spending: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String,
         color: String,
         logoURL: String,
         spending: String) {
        self.title = title
        self.color = color
        self.logoURL = logoURL
        self.spending = spending
    }

    var description: String {
        return title
    }
}
