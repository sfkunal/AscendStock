//
//  ATCFinanceTransaction.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/20/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceTransaction: ATCGenericBaseModel {
    var title: String
    var isPositive: Bool
    var price: String
    var imageURL: String
    var date: Date

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String,
         isPositive: Bool,
         price: String,
         imageURL: String = "",
         date: Date) {
        self.title = title
        self.isPositive = isPositive
        self.price = price
        self.imageURL = imageURL
        self.date = date
    }

    var description: String {
        return title
    }
}
