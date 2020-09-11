

import UIKit

class ATCWalkthroughModel: ATCGenericBaseModel {
    var title: String
    var subtitle: String
    var icon: String

    init(title: String, subtitle: String, icon: String) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }

    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

    var description: String {
        return title
    }
}
