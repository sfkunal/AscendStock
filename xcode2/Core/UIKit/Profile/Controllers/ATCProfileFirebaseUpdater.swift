//
//  ATCProfileFirebaseUpdated.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit

class ATCProfileFirebaseUpdater: ATCProfileUpdaterProtocol {
    var usersTable: String
    init(usersTable: String) {
        self.usersTable = usersTable
    }

    func removePhoto(url: String, user: ATCUser, completion: @escaping () -> Void) {
        guard let uid = user.uid else { return }
        if let photos = user.photos {
            let remainingPhotos = photos.filter({$0 != url})
            Firestore
                .firestore()
                .collection(self.usersTable)
                .document(uid)
                .setData(["photos": remainingPhotos], merge: true, completion: { (error) in
                    user.photos = remainingPhotos
                    completion()
                })
        }
    }

    func uploadPhoto(image: UIImage, user: ATCUser, isProfilePhoto: Bool, completion: @escaping () -> Void) {
        self.uploadImage(image, completion: {[weak self] (url) in
            guard let `self` = self, let url = url?.absoluteString, let uid = user.uid else { return }
            var photos: [String] = (user.photos ?? []) + [url]
            if photos.count == 0 && isProfilePhoto {
                photos = [url]
            }
            let data = ((isProfilePhoto) ?
                ["photos": photos, "profilePictureURL": url] :
                ["photos": photos])
            Firestore
                .firestore()
                .collection(self.usersTable)
                .document(uid)
                .setData(data, merge: true, completion: { (error) in
                    user.photos = photos
                    if (isProfilePhoto) {
                        user.profilePictureURL = url
                    }
                    completion()
                })
        })
    }

    func update(user: ATCUser, email: String, firstName: String, lastName: String, username: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let uid = user.uid else { return }
        let usersRef = Firestore.firestore().collection(usersTable).document(uid)
        let data: [String: Any] = [
            "lastName": lastName,
            "firstName": firstName,
            "username": username,
            "email": email
        ]
        usersRef.setData(data, merge: true) { (error) in
            NotificationCenter.default.post(name: kATCLoggedInUserDataDidChangeNotification, object: nil)
            completion(error == nil)
        }
    }

    func updateLocation(for user: ATCUser, to location: ATCLocation, completion: @escaping (_ success: Bool) -> Void) {
        guard let uid = user.uid else { return }
        let usersRef = Firestore.firestore().collection(usersTable).document(uid)
        let data: [String: Any] = [
            "location": location.representation,
        ]
        usersRef.setData(data, merge: true) { (error) in
            completion(error == nil)
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        let storage = Storage.storage().reference()

        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let ref = storage.child(usersTable).child(imageName)
        ref.putData(data, metadata: metadata) { meta, error in
            ref.downloadURL { (url, error) in
                completion(url)
            }
        }
    }
}
