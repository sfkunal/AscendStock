

import UIKit

class CardFooterModel: ATCGenericBaseModel {
    var title: String
    
    required init(jsonDict: [String: Any]) {
        fatalError()
    }
    
    init(title: String) {
        self.title = title
    }
    
    var description: String {
        return title
    }
}
