//
//  ATCFinanceAssetStats.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/23/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceAssetStats: ATCGenericBaseModel {
    var open: String
    var high: String
    var low: String
    var wk52High: String
    var wk52Low: String
    var volume: String
    var avgVol: String
    var mktCap: String
    var peRatio: String
    var divYield: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(open: String,
         high: String,
         low: String,
         wk52High: String,
        wk52Low: String,
        volume: String,
        avgVol: String,
        mktCap: String,
        peRatio: String,
        divYield: String) {
        self.open = open
        self.high = high
        self.low = low
        self.wk52High = wk52High
        self.wk52Low = wk52Low
        self.volume = volume
        self.avgVol = avgVol
        self.mktCap = mktCap
        self.peRatio = peRatio
        self.divYield = divYield
    }

    var description: String {
        return avgVol
    }
}
