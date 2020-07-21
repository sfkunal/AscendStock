//
//  ATCMessengerUserCollectionViewCell.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/22/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

protocol ATCMessengerUserCollectionViewCellDelegate: class  {
    func messengerUserCell(_ cell: ATCMessengerUserCollectionViewCell, didTapAddFriendButtonFor user: ATCUser)
    func messengerUserCell(_ cell: ATCMessengerUserCollectionViewCell, didTapButtonFor friendship: ATCChatFriendship)
}

class ATCMessengerUserCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameContainerView: UIView!
    @IBOutlet var avatarContainerView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var borderView: UIView!
    @IBOutlet var chekedImageView: UIImageView!
    @IBOutlet var addButton: UIButton!

    weak var delegate: ATCMessengerUserCollectionViewCellDelegate?

    // This is cell is used for both users & friendships. Set only one of these two:
    var user: ATCUser?
    var friendship: ATCChatFriendship?

    @IBAction func addButtonTapped(_sender: Any) {
        if let user = user {
            delegate?.messengerUserCell(self, didTapAddFriendButtonFor: user)
        } else if let friendship = friendship {
            delegate?.messengerUserCell(self, didTapButtonFor: friendship)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addButton.setTitleColor(.black, for: .normal)
    }
    
}
