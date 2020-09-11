

import Charts
import UIKit

class ATCBarChartGroup: ATCGenericBaseModel {
    let numbers: [Double]
    let name: String
    init(numbers: [Double], name: String) {
        self.numbers = numbers
        self.name = name
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    var description: String {
        return ""
    }
}

class ATCBarChart: ATCGenericBaseModel {
    let groups: [ATCBarChartGroup]
    let labels: [String]
    let name: String
    let valueFormat: String

    init(groups: [ATCBarChartGroup], name: String, labels: [String], valueFormat: String) {
        self.groups = groups
        self.valueFormat = valueFormat
        self.name = name
        self.labels = labels
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    var description: String {
        return ""
    }
}
