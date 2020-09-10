//
//  ATCFinanceAssetPosition.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/23/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceAssetPosition: ATCGenericBaseModel {
    var title: String
    var shares: Double
    var equity: String
    var portfolioDiversity: String
    var avgCost: String
    var totalReturn: String
    var todayReturn: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String,
         shares: Double,
         equity: String,
         avgCost: String,
         portfolioDiversity: String,
         totalReturn: String,
         todayReturn: String) {
        self.title = title
        self.shares = shares
        self.equity = equity
        self.avgCost = avgCost
        self.portfolioDiversity = portfolioDiversity
        self.totalReturn = totalReturn
        self.todayReturn = todayReturn
    }

    var description: String {
        return totalReturn
    }
}
