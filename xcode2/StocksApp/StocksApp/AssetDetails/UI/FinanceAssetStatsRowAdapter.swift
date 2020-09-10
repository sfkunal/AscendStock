

import UIKit

class FinanceAssetStatsRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let stats = object as? ATCFinanceAssetStats, let cell = cell as? FinanceAssetStatsCollectionViewCell {

            cell.titleView.text = "Stats"
            cell.titleView.textColor = uiConfig.mainTextColor
            cell.titleView.font = uiConfig.boldFont(size: 20)

            cell.openTitleLabel.text = "Open".uppercased()
            cell.openTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.openTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.openLabel.text = String(stats.open)
            cell.openLabel.textColor = uiConfig.mainTextColor
            cell.openLabel.font = uiConfig.regularFont(size: 18)
            cell.openBorderView.backgroundColor = uiConfig.hairlineColor

            cell.highTitleLabel.text = "High".uppercased()
            cell.highTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.highTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.highLabel.text = String(stats.high)
            cell.highLabel.textColor = uiConfig.mainTextColor
            cell.highLabel.font = uiConfig.regularFont(size: 18)
            cell.highBorderView.backgroundColor = uiConfig.hairlineColor

            cell.lowTitleLabel.text = "Low".uppercased()
            cell.lowTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.lowTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.lowLabel.text = String(stats.low)
            cell.lowLabel.textColor = uiConfig.mainTextColor
            cell.lowLabel.font = uiConfig.regularFont(size: 18)
            cell.lowBorderView.backgroundColor = uiConfig.hairlineColor

            cell.wkHighTitleLabel.text = "52 WK High".uppercased()
            cell.wkHighTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.wkHighTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.wkHighLabel.text = String(stats.wk52High)
            cell.wkHighLabel.textColor = uiConfig.mainTextColor
            cell.wkHighLabel.font = uiConfig.regularFont(size: 18)
            cell.wkHighBorderView.backgroundColor = uiConfig.hairlineColor

            cell.wkLowTitleLabel.text = "52 WK Low".uppercased()
            cell.wkLowTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.wkLowTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.wkLowLabel.text = String(stats.wk52Low)
            cell.wkLowLabel.textColor = uiConfig.mainTextColor
            cell.wkLowLabel.font = uiConfig.regularFont(size: 18)
            cell.wkLowBorderView.backgroundColor = uiConfig.hairlineColor

            cell.volumeTitleLabel.text = "Volume".uppercased()
            cell.volumeTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.volumeTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.volumeLabel.text = String(stats.volume)
            cell.volumeLabel.textColor = uiConfig.mainTextColor
            cell.volumeLabel.font = uiConfig.regularFont(size: 18)
            cell.volumeBorderView.backgroundColor = uiConfig.hairlineColor

            cell.avgVolumeTitleLabel.text = "AVG Vol".uppercased()
            cell.avgVolumeTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.avgVolumeTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.avgVolumeLabel.text = String(stats.avgVol)
            cell.avgVolumeLabel.textColor = uiConfig.mainTextColor
            cell.avgVolumeLabel.font = uiConfig.regularFont(size: 18)
            cell.avgVolumeBorderView.backgroundColor = uiConfig.hairlineColor

            cell.capTitleLabel.text = "MKT CAP".uppercased()
            cell.capTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.capTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.capLabel.text = String(stats.mktCap)
            cell.capLabel.textColor = uiConfig.mainTextColor
            cell.capLabel.font = uiConfig.regularFont(size: 18)
            cell.capBorderView.backgroundColor = uiConfig.hairlineColor

            cell.peTitleLabel.text = "P/E RATIO".uppercased()
            cell.peTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.peTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.peLabel.text = String(stats.peRatio)
            cell.peLabel.textColor = uiConfig.mainTextColor
            cell.peLabel.font = uiConfig.regularFont(size: 18)
            cell.peBorderView.backgroundColor = uiConfig.hairlineColor

            cell.divTitleLabel.text = "Div/Yield".uppercased()
            cell.divTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.divTitleLabel.font = uiConfig.boldFont(size: 14)
            cell.divLabel.text = String(stats.divYield)
            cell.divLabel.textColor = uiConfig.mainTextColor
            cell.divLabel.font = uiConfig.regularFont(size: 18)
            cell.divBorderView.backgroundColor = uiConfig.hairlineColor

            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return FinanceAssetStatsCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCFinanceAssetStats else { return .zero }
        return CGSize(width: containerBounds.width, height: 250)
    }
}
