//
//  ATCPersistentStore.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/16/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCPersistentStore {

    private static let kWalkthroughCompletedKey = "kWalkthroughCompletedKey"
    private static let kLoggedInUserKey = "kUserKey"

    func markWalkthroughCompleted() {
        UserDefaults.standard.set(true, forKey: ATCPersistentStore.kWalkthroughCompletedKey)
    }

    func isWalkthroughCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: ATCPersistentStore.kWalkthroughCompletedKey)
    }

    func markUserAsLoggedIn(user: ATCUser) {
        let res = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(res, forKey: ATCPersistentStore.kLoggedInUserKey)
    }

    func userIfLoggedInUser() -> ATCUser? {
        if let data = UserDefaults.standard.value(forKey: ATCPersistentStore.kLoggedInUserKey) as? Data,
            let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: data) {
            return unarchivedData as? ATCUser
        }
        return nil
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: ATCPersistentStore.kLoggedInUserKey)
    }
}
