

import UIKit

protocol ATCProfileUpdaterProtocol: class {
    func removePhoto(url: String, user: ATCUser, completion: @escaping () -> Void)
    func uploadPhoto(image: UIImage, user: ATCUser, isProfilePhoto: Bool, completion: @escaping () -> Void)
    func update(user: ATCUser,
                email: String,
                firstName: String,
                lastName: String,
                username: String,
                completion: @escaping (_ success: Bool) -> Void)
    func updateLocation(for user: ATCUser, to location: ATCLocation, completion: @escaping (_ success: Bool) -> Void)
}
