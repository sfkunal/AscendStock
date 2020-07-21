//
//  ATCUser.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Foundation

open class ATCUser: NSObject, ATCGenericBaseModel, NSCoding {

    private static let defaultAvatarURL = "https://www.iosapptemplates.com/wp-content/uploads/2019/06/empty-avatar.jpg"

    var uid: String?
    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var profilePictureURL: String?
    var pushToken: String?
    var isOnline: Bool
    var photos: [String]? = nil
    var location: ATCLocation? = nil
    var hasDefaultAvatar: Bool

    init(uid: String = "",
         firstName: String,
         lastName: String,
         avatarURL: String? = nil,
         email: String = "",
         pushToken: String? = nil,
         photos: [String]? = [],
         isOnline: Bool = false,
         location: ATCLocation? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.email = email
        self.profilePictureURL = ((avatarURL?.count ?? 0) > 0 ? avatarURL : ATCUser.defaultAvatarURL)
        self.hasDefaultAvatar = (avatarURL == nil || avatarURL == "")
        self.pushToken = pushToken
        self.photos = photos
        self.isOnline = isOnline
        self.location = location
    }

    public init(representation: [String: Any]) {
        self.firstName = representation["firstName"] as? String
        self.lastName = representation["lastName"] as? String
        let avatarURL = representation["profilePictureURL"] as? String
        self.profilePictureURL = (avatarURL?.count ?? 0) > 0 ? avatarURL : ATCUser.defaultAvatarURL
        self.hasDefaultAvatar = (avatarURL == nil || avatarURL == "")
        self.username = representation["username"] as? String
        self.email = representation["email"] as? String
        self.uid = representation["userID"] as? String
        self.pushToken = representation["fcmToken"] as? String
        self.photos = representation["photos"] as? [String]

        var location: ATCLocation? = nil
        if let locationDict = representation["location"] as? [String: Any] {
            location = ATCLocation(representation: locationDict)
        }
        self.location = location

        self.isOnline = false
    }

    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(profilePictureURL, forKey: "profilePictureURL")
        aCoder.encode(pushToken, forKey: "pushToken")
        aCoder.encode(isOnline, forKey: "isOnline")
        aCoder.encode(photos, forKey: "photos")
        aCoder.encode(location, forKey: "location")
    }

    public convenience required init?(coder aDecoder: NSCoder) {
        self.init(uid: aDecoder.decodeObject(forKey: "uid") as? String ?? "unknown",
                  firstName: aDecoder.decodeObject(forKey: "firstName") as? String ?? "",
                  lastName: aDecoder.decodeObject(forKey: "lastName") as? String ?? "",
                  avatarURL: aDecoder.decodeObject(forKey: "profilePictureURL") as? String ?? ATCUser.defaultAvatarURL,
                  email: aDecoder.decodeObject(forKey: "email") as? String ?? "",
                  pushToken: aDecoder.decodeObject(forKey: "pushToken") as? String ?? "",
                  photos: aDecoder.decodeObject(forKey: "photos") as? [String] ?? [],
                  isOnline: aDecoder.decodeBool(forKey: "isOnline"),
                  location: aDecoder.decodeObject(forKey: "location") as? ATCLocation)
    }

//    public func mapping(map: Map) {
//        username            <- map["username"]
//        email               <- map["email"]
//        firstName           <- map["first_name"]
//        lastName            <- map["last_name"]
//        profilePictureURL   <- map["profile_picture"]
//    }

    public func fullName() -> String {
        guard let firstName = firstName, let lastName = lastName else { return self.firstName ?? "" }
        return "\(firstName) \(lastName)"
    }

    public func firstWordFromName() -> String {
        if let firstName = firstName, let first = firstName.components(separatedBy: " ").first {
            return first
        }
        return "No name"
    }

    var initials: String {
        if let f = firstName?.first, let l = lastName?.first {
            return String(f) + String(l)
        }
        return "?"
    }

    var representation: [String : Any] {
        var rep: [String : Any] = [
            "userID": uid ?? "default",
            "profilePictureURL": profilePictureURL ?? ATCUser.defaultAvatarURL,
            "username": username ?? "",
            "email": email ?? "",
            "firstName": firstName ?? "",
            "lastName": lastName ?? "",
            "pushToken": pushToken ?? "",
            "photos": photos ?? "",
            ]
        if let location = location {
            rep["location"] = location.representation
        }
        return rep
    }
}
