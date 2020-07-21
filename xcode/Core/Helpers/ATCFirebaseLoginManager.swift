//
//  ATCFirebaseLoginManager.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/6/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

public class ATCFirebaseLoginManager {
    let userManager: ATCSocialFirebaseUserManager

    init() {
        self.userManager = ATCSocialFirebaseUserManager()
    }

    static func login(credential: AuthCredential, completionBlock: @escaping (_ user: ATCUser?) -> Void) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            completionBlock(ATCFirebaseLoginManager.atcUser(for: authResult?.user))
        }
    }

    static func signIn(email: String, pass: String, completionBlock: @escaping (_ user: ATCUser?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let errCode = AuthErrorCode(rawValue: error._code) {
                switch errCode {
                case .userNotFound:
                    Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                        if error == nil {
                            ATCFirebaseLoginManager.signIn(email: email, pass: pass, completionBlock:completionBlock)
                        }
                    }
                default:
                    return
                }
            } else {
                completionBlock(ATCFirebaseLoginManager.atcUser(for: result?.user))
            }
        }
    }

    static func atcUser(for firebaseUser: User?) -> ATCUser? {
        guard let fUser = firebaseUser else { return nil }
        return ATCUser(uid: fUser.uid, firstName: fUser.displayName ?? "", lastName: "", avatarURL: fUser.providerData[0].photoURL?.absoluteString ?? "", email: fUser.email ?? "")
    }

    func saveUserToServerIfNeeded(user: ATCUser, appIdentifier: String) {
        let ref = Firestore.firestore().collection("users")
        if let uid = user.uid {
            var dict = user.representation
            dict["appIdentifier"] = appIdentifier
            ref.document(uid).setData(dict, merge: true)
        }
    }

    func resyncPersistentUser(user: ATCUser, completionBlock: @escaping (_ user: ATCUser?) -> Void) {
        if let uid = user.uid {
            self.userManager.fetchUser(userID: uid) { (newUser) in
                if let newUser = newUser {
                    completionBlock(newUser)
                } else {
                    // User is no longer existing
                    NotificationCenter.default.post(name: kLogoutNotificationName, object: nil)
                }
            }
        }
    }
}
