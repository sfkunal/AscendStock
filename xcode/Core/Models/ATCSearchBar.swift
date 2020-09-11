

import UIKit

class ATCSearchBar: ATCGenericBaseModel {
    var placeholder: String

    init(placeholder: String) {
        self.placeholder = placeholder
    }
    required init(jsonDict: [String: Any]) {
        fatalError()
    }
    var description: String {
        return "searchbar"
    }
}
