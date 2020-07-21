
import UIKit

class CardHeaderRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let header = object as? CardHeaderModel, let cell = cell as? CardHeaderCollectionViewCell {
            cell.headerTitleLabel.text = header.title
            cell.headerTitleLabel.textColor = uiConfig.mainTextColor
            cell.headerTitleLabel.font = uiConfig.boldFont(size: 20)

            cell.bottomBorderView.backgroundColor = uiConfig.hairlineColor

            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return CardHeaderCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? CardHeaderModel else { return .zero }
        return CGSize(width: containerBounds.width, height: 70)
    }
}
