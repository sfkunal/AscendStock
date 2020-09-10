//
//  ATCChatProfileManager.swift
//  ChatApp
//
//  Created by Osama Naeem on 28/05/2019.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ATCFirebaseProfileManager : ATCProfileManager {
    let db = Firestore.firestore()
    var usersListener: ListenerRegistration? = nil

    var delegate: ATCProfileManagerDelegate?
    
    func fetchProfile(for user: ATCUser) {
        //...
    }
    
    func update(profile: ATCUser, email: String, firstName: String, lastName: String, phone: String) {
        let documentRef = db.collection("users").document("\(profile.uid!)")
        
        documentRef.updateData([
            "firstName" : firstName,
            "lastName"  : lastName,
            "email"     : email,
            "phone"     : phone,
            "userID"    : profile.uid!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                self.delegate?.profileEditManager(self, didUpdateProfile: false)
            } else {
                print("Successfully updated")
                self.delegate?.profileEditManager(self, didUpdateProfile: true)
            }
        }
    }
}
