

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell, ATCMenuItemCollectionViewCellProtocol {

    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuLabel: UILabel!

    func configure(item: ATCNavigationItem) {
        menuImageView.image = item.image
        menuLabel.text = item.title
    }
}
