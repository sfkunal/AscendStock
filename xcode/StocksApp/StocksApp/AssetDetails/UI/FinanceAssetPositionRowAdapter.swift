

import UIKit

class FinanceAssetPositionRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let position = object as? ATCFinanceAssetPosition, let cell = cell as? FinanceAssetPositionCollectionViewCell {

            cell.positionTitleLabel.text = position.title
            cell.positionTitleLabel.textColor = uiConfig.mainTextColor
            cell.positionTitleLabel.font = uiConfig.boldFont(size: 20)

            cell.sharesTitleLabel.text = "Shares".uppercased()
            cell.sharesTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.sharesTitleLabel.font = uiConfig.boldFont(size: 12)

            cell.sharesLabel.text = String(position.shares)
            cell.sharesLabel.textColor = uiConfig.mainTextColor
            cell.sharesLabel.font = uiConfig.regularFont(size: 18)

            cell.equityTitleLabel.text = "Equity".uppercased()
            cell.equityTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.equityTitleLabel.font = uiConfig.boldFont(size: 12)

            cell.equityLabel.text = position.equity
            cell.equityLabel.textColor = uiConfig.mainTextColor
            cell.equityLabel.font = uiConfig.regularFont(size: 18)

            cell.avgCostTitleLabel.text = "Avg Cost".uppercased()
            cell.avgCostTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.avgCostTitleLabel.font = uiConfig.boldFont(size: 12)

            cell.avgCostLabel.text = position.avgCost
            cell.avgCostLabel.textColor = uiConfig.mainTextColor
            cell.avgCostLabel.font = uiConfig.regularFont(size: 18)

            cell.diversityTitleLabel.text = "Portfolio Diversity".uppercased()
            cell.diversityTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.diversityTitleLabel.font = uiConfig.boldFont(size: 12)

            cell.diversityLabel.text = position.portfolioDiversity
            cell.diversityLabel.textColor = uiConfig.mainTextColor
            cell.diversityLabel.font = uiConfig.regularFont(size: 18)


            cell.todayTitleLabel.text = "Today's Return".uppercased()
            cell.todayTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.todayTitleLabel.font = uiConfig.boldFont(size: 12)
            cell.todayLabel.text = position.todayReturn
            cell.todayLabel.textColor = uiConfig.mainTextColor
            cell.todayLabel.font = uiConfig.regularFont(size: 18)

            cell.totalTitleLabel.text = "Total Return".uppercased()
            cell.totalTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.totalTitleLabel.font = uiConfig.boldFont(size: 12)
            cell.totalLabel.text = position.totalReturn
            cell.totalLabel.textColor = uiConfig.mainTextColor
            cell.totalLabel.font = uiConfig.regularFont(size: 18)

            cell.todayBorderBottomView.backgroundColor = uiConfig.hairlineColor
            cell.totalBorderBottomView.backgroundColor = uiConfig.hairlineColor

            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return FinanceAssetPositionCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCFinanceAssetPosition else { return .zero }
        return CGSize(width: containerBounds.width, height: 250)
    }
}
