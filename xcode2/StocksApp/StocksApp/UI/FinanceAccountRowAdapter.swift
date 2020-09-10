

import UIKit

class FinanceAccountRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let account = object as? ATCFinanceAccount, let cell = cell as? FinanceAccountCollectionViewCell {
            cell.imageView.kf.setImage(with: URL(string: account.logoURL))
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.tintColor = .white
            cell.imageView.backgroundColor = UIColor(hexString: account.color)
            cell.imageView.layer.cornerRadius = 40 / 2
            cell.imageView.clipsToBounds = true

            cell.institutionLabel.text = account.institution.uppercased()
            cell.institutionLabel.textColor = uiConfig.mainSubtextColor
            cell.institutionLabel.font = uiConfig.boldFont(size: 12)

            cell.accountTitleLabel.text = account.title
            cell.accountTitleLabel.textColor = uiConfig.mainTextColor
            cell.accountTitleLabel.font = uiConfig.regularFont(size: 18)

            cell.amountLabel.text = account.amount
            cell.amountLabel.textColor = uiConfig.mainTextColor
            cell.amountLabel.font = uiConfig.regularFont(size: 18)

            cell.bottomBorderView.backgroundColor = uiConfig.hairlineColor
            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return FinanceAccountCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCFinanceAccount else { return .zero }
        return CGSize(width: containerBounds.width, height: 70)
    }
}
