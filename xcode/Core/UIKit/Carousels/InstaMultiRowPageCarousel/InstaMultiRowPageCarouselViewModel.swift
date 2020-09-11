

import UIKit

class InstaMultiRowPageCarouselViewModel: ATCGenericBaseModel {
    var description: String = "InstaMultiRowPageCarouselViewModel"

    let cellHeight: CGFloat
    let title: String
    var viewController: ATCGenericCollectionViewController
    weak var parentViewController: UIViewController?

    init(title: String, viewController: ATCGenericCollectionViewController, cellHeight: CGFloat) {
        self.cellHeight = cellHeight
        self.title = title
        self.viewController = viewController
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}
