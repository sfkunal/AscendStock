

import UIKit

class ATCKeyboardKey: ATCGenericBaseModel {
    var value: String
    var displayValue: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(value: String, displayValue: String) {
        self.value = value
        self.displayValue = displayValue
    }

    var description: String {
        return displayValue
    }
}
