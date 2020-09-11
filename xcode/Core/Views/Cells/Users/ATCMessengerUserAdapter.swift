

import UIKit

protocol ATCMessengerUserAdapterDelegate: class {
    func userAdapter(_ userAdapter: ATCMessengerUserAdapter, didTapAddUser user: ATCUser)
}

class ATCMessengerUserAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol
    weak var delegate: ATCMessengerUserAdapterDelegate? = nil
    let friends: [ATCUser]

    init(uiConfig: ATCUIGenericConfigurationProtocol, friends: [ATCUser]) {
        self.uiConfig = uiConfig
        self.friends = friends
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let user = object as? ATCUser, let cell = cell as? ATCMessengerUserCollectionViewCell {
            if let url = user.profilePictureURL {
                cell.avatarImageView.kf.setImage(with: URL(string: url))
            } else {
                // placeholder
            }
            cell.avatarImageView.contentMode = .scaleAspectFill
            cell.avatarImageView.clipsToBounds = true
            cell.avatarImageView.layer.cornerRadius = 40 / 2.0

            cell.nameLabel.text = (user.firstName ?? "") + " " +  (user.lastName ?? "")
            cell.nameLabel.font = uiConfig.boldSmallFont
            cell.nameLabel.textColor = uiConfig.mainTextColor
            
            cell.borderView.backgroundColor = UIColor(hexString: "#e6e6e6")
            
            cell.addButton.isHidden = friends.contains(where: { (u) -> Bool in
                return u.uid == user.uid
            })
            cell.addButton.layer.cornerRadius = 15
            cell.addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.delegate = self
            cell.user = user
            cell.setNeedsLayout()
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCMessengerUserCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard object is ATCUser else { return .zero }
        return CGSize(width: containerBounds.width, height: 60)
    }
    
}

extension ATCMessengerUserAdapter : ATCMessengerUserCollectionViewCellDelegate {
    func messengerUserCell(_ cell: ATCMessengerUserCollectionViewCell, didTapAddFriendButtonFor user: ATCUser) {
        delegate?.userAdapter(self, didTapAddUser: user)
    }

    func messengerUserCell(_ cell: ATCMessengerUserCollectionViewCell, didTapButtonFor friendship: ATCChatFriendship) {}
}
