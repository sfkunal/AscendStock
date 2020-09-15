

import UIKit

class TransactionsRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let transaction = object as? ATCFinanceTransaction, let cell = cell as? TransactionCollectionViewCell {
            if transaction.imageURL.count == 0 {
                let placeholder = UIImage.localImage("storefront-icon", template: true)
                cell.imageView.image = placeholder
                cell.imageView.backgroundColor = UIColor(hexString: "#687072")
                cell.imageView.contentMode = .center
            } else {
                cell.imageView.kf.setImage(with: URL(string: transaction.imageURL))
                cell.imageView.contentMode = .scaleAspectFit
            }
            cell.imageView.tintColor = .white
            cell.imageView.layer.cornerRadius = 50 / 2
            cell.imageView.clipsToBounds = true

            cell.titleLabel.text = transaction.title
            cell.titleLabel.textColor = uiConfig.mainTextColor
            cell.titleLabel.font = uiConfig.regularFont(size: 16)

            cell.priceLabel.text = transaction.price
            if (transaction.isPositive) {
                cell.priceLabel.textColor = UIColor(hexString: "#5ccb96")
            } else {
                cell.priceLabel.textColor = uiConfig.mainTextColor
            }
            cell.priceLabel.font = uiConfig.boldFont(size: 16)

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd"
            cell.dateLabel.text = dateFormatterPrint.string(from: transaction.date)
            cell.dateLabel.textColor = uiConfig.mainSubtextColor
            cell.dateLabel.font = uiConfig.regularFont(size: 14)

            cell.bottomBorderView.backgroundColor = uiConfig.hairlineColor

            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return TransactionCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard object is ATCFinanceTransaction else { return .zero }
        return CGSize(width: containerBounds.width, height: 70)
    }
}
