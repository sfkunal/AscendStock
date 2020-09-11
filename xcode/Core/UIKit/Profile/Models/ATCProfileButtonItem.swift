

import UIKit

class ATCProfileButtonItem: ATCGenericBaseModel {
    var title: String
    var color: UIColor?
    var textColor: UIColor?

    init(title: String, color: UIColor?, textColor: UIColor?) {
        self.title = title
        self.color = color
        self.textColor = textColor
    }

    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

    public var description: String {
        return title
    }
}
