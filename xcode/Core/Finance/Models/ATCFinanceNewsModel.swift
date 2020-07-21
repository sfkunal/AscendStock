//
//  FinanceNewsModel.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/16/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceNewsModel: ATCGenericBaseModel {
    var title: String
    var publication: String
    var createdAt: Date
    var url: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String, publication: String, createdAt: Date, url: String) {
        self.title = title
        self.publication = publication
        self.createdAt = createdAt
        self.url = url
    }

    var description: String {
        return title
    }

    var subtitle: String {
        return self.publication + "\u{2022}" + TimeFormatHelper.timeAgoString(date: createdAt)
    }
}
