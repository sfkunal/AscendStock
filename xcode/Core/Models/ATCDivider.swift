
import UIKit

class ATCDivider: ATCGenericBaseModel {

    var title: String?

    convenience init(_ title: String? = nil) {
        self.init(jsonDict: [:])
        self.title = title
    }

    required init(jsonDict: [String: Any]) {}
    var description: String {
        return "divider"
    }
}
