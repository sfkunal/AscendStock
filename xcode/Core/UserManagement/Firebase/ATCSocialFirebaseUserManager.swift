

import FirebaseFirestore
import UIKit

class ATCSocialFirebaseUserManager: ATCSocialUserManagerProtocol {
    func fetchUser(userID: String, completion: @escaping (_ user: ATCUser?) -> Void) {
        let usersRef = Firestore.firestore().collection("users").whereField("userID", isEqualTo: userID)
        usersRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let document = querySnapshot.documents.first {
                let data = document.data()
                let user = ATCUser(representation: data)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
