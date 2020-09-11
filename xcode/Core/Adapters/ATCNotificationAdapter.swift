

import UIKit

class ATCNotificationAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATCNotification, let cell = cell as? ATCNotificationCollectionViewCell else { return }
        cell.hairlineView.backgroundColor = uiConfig.hairlineColor

        cell.categoryLabel.text = viewModel.category
        cell.categoryLabel.textColor = UIColor(hexString: "#BCC8CE")
        cell.categoryLabel.font = uiConfig.regularSmallFont

        cell.contentLabel.text = viewModel.content
        cell.contentLabel.textColor = UIColor(hexString: "#96999B")
        cell.contentLabel.font = uiConfig.regularMediumFont

        cell.timeLabel.text = TimeFormatHelper.timeAgoString(date: viewModel.createdAt)
        cell.timeLabel.textColor = UIColor(hexString: "#BCC8CE")
        cell.timeLabel.font = uiConfig.italicMediumFont

        cell.badgeView.isHidden = !viewModel.isNotSeen
        cell.badgeView.backgroundColor = UIColor(hexString: "#F4771E")
        cell.badgeView.clipsToBounds = true
        cell.badgeView.layer.cornerRadius = 5

        cell.notificationImageView.tintColor = UIColor(hexString: "#96999B")
        cell.notificationImageView.image = UIImage.localImage(viewModel.icon, template: true)

        cell.setNeedsLayout()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCNotificationCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCNotification else { return .zero }
        return CGSize(width: containerBounds.width, height: 100)
    }
}
