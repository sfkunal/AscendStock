

import UIKit

class FinanceNewsRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let news = object as? ATCFinanceNewsModel, let cell = cell as? FinanceNewsCollectionViewCell {
            cell.newsTitleLabel.text = news.title
            cell.newsTitleLabel.textColor = uiConfig.mainTextColor
            cell.newsTitleLabel.font = uiConfig.boldFont(size: 18)

            cell.newsSubtitleLabel.text = news.subtitle
            cell.newsSubtitleLabel.textColor = uiConfig.mainSubtextColor
            cell.newsSubtitleLabel.font = uiConfig.regularFont(size: 12)

            cell.bottomBorderView.backgroundColor = uiConfig.hairlineColor
            cell.containerView.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return FinanceNewsCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCFinanceNewsModel else { return .zero }
        return CGSize(width: containerBounds.width, height: 100)
    }
}
