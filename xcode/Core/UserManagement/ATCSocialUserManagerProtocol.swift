

import UIKit

let kATCLoggedInUserDataDidChangeNotification = Notification.Name("kATCLoggedInUserDataDidChangeNotification")

protocol ATCSocialUserManagerProtocol: class {
    func fetchUser(userID: String, completion: @escaping (_ user: ATCUser?) -> Void)
}
