

import UIKit

struct ATCFilterOption {
    var id: String
    var name: String
}

class ATCSelectFilter: ATCGenericBaseModel {
    var id: String
    var options: [ATCFilterOption]
    var title: String
    var selectedOption: ATCFilterOption?

    init(id: String, title: String, options: [ATCFilterOption]) {
        self.id = id
        self.options = options
        self.title = title
        if let first = options.first {
            self.selectedOption = first
        }
    }

    required init(jsonDict: [String: Any]) {
        self.id = jsonDict["id"] as? String ?? ""
        self.title = jsonDict["name"] as? String ?? ""

        var options: [ATCFilterOption] = [ATCFilterOption(id: "all_id", name: "All")]
        for optionStr in (jsonDict["options"] as? [String] ?? []) {
            options.append(ATCFilterOption(id: "firebase_option_id", name: optionStr))
        }
        self.options = options
        if let first = options.first {
            self.selectedOption = first
        }
    }

    var description: String {
        return self.id
    }
}
