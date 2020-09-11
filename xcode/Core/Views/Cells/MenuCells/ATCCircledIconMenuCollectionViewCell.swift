

import UIKit

class ATCCircledIconMenuCollectionViewCell: UICollectionViewCell, ATCMenuItemCollectionViewCellProtocol {
    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var imageContainerView: UIView!
    
    func configure(item: ATCNavigationItem) {
        menuImageView.image = item.image
        menuLabel.text = item.title

        imageContainerView.layer.cornerRadius = 30 / 2
        imageContainerView.layer.borderColor = UIColor.gray.cgColor
        imageContainerView.layer.borderWidth = 1.0
    }
}
