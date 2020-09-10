//
//  ATCFinanceAccount.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/20/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceAccount: ATCGenericBaseModel {
    var title: String
    var color: String
    var logoURL: String
    var institution: String
    var amount: String
    var isPositive: Bool

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String,
         color: String,
         logoURL: String,
         amount: String,
         isPositive: Bool,
         institution: String) {
        self.title = title
        self.color = color
        self.logoURL = logoURL
        self.amount = amount
        self.institution = institution
        self.isPositive = isPositive
    }

    var description: String {
        return title
    }
}
