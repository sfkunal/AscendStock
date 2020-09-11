

import UIKit

class InstaLinedPageCarouselViewModel: ATCGenericBaseModel {
    var description: String = "InstaLinedPageCarouselViewModel"

    let cellHeight: CGFloat
    var viewController: ATCGenericCollectionViewController
    weak var parentViewController: UIViewController?

    init(viewController: ATCGenericCollectionViewController, cellHeight: CGFloat) {
        self.cellHeight = cellHeight
        self.viewController = viewController
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}
