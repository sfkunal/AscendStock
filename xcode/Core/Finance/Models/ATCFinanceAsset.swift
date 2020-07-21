//
//  ATCFinanceAsset.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/16/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceAsset: NSObject, NSCoding, ATCGenericBaseModel, ATCPersistable {
    var title: String
    var ticker: String
    var priceChange: String
    var isPositive: Bool
    var price: String
    var color: String
    var logoURL: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String,
         ticker: String,
         priceChange: String,
         isPositive: Bool,
         price: String,
         color: String,
         logoURL: String) {
        self.title = title
        self.ticker = ticker
        self.priceChange = priceChange
        self.isPositive = isPositive
        self.price = price
        self.color = color
        self.logoURL = logoURL
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(ticker, forKey: "ticker")
        aCoder.encode(priceChange, forKey: "priceChange")
        aCoder.encode(isPositive, forKey: "isPositive")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(logoURL, forKey: "logoURL")
    }

    public convenience required init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let ticker = aDecoder.decodeObject(forKey: "ticker") as! String
        let priceChange = aDecoder.decodeObject(forKey: "priceChange") as! String
        let isPositive = aDecoder.decodeBool(forKey: "isPositive")
        let price = aDecoder.decodeObject(forKey: "price") as! String
        let color = aDecoder.decodeObject(forKey: "color") as! String
        let logoURL = aDecoder.decodeObject(forKey: "logoURL") as! String
        self.init(title: title,
                  ticker: ticker,
                  priceChange: priceChange,
                  isPositive: isPositive,
                  price: price,
                  color: color,
                  logoURL: logoURL)
    }

    var diffIdentifier: String {
        return ticker
    }
}
