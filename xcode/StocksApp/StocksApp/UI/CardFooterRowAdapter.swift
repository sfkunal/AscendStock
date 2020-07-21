

import UIKit

class CardFooterRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let footer = object as? CardFooterModel, let cell = cell as? CardFooterCollectionViewCell {
            cell.footerTitleLabel.text = footer.title
            cell.footerTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.footerTitleLabel.font = uiConfig.boldFont(size: 15)

            cell.footerImageView.image = UIImage.localImage("forward-arrow-black", template: true)
            cell.footerImageView.tintColor = uiConfig.mainSubtextColor
            cell.footerImageView.alpha = 0.9

            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return CardFooterCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? CardFooterModel else { return .zero }
        return CGSize(width: containerBounds.width, height: 70)
    }
}
