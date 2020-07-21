

import UIKit

class FinanceInstitutionRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    weak var delegate: AddBankAccountButtonRowAdapterDelegate?

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let institution = object as? ATCFinanceInstitution, let cell = cell as? FinanceInstitutionCollectionViewCell {
            cell.imageView.kf.setImage(with: URL(string: institution.imageUrl))
            cell.imageView.contentMode = .scaleToFill
            cell.imageView.layer.cornerRadius = 60 / 2
            cell.imageView.clipsToBounds = true

            cell.titleLabel.text = institution.title
            cell.titleLabel.textColor = uiConfig.mainSubtextColor
            cell.titleLabel.font = uiConfig.regularFont(size: 14)

            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return FinanceInstitutionCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard object is ATCFinanceInstitution else { return .zero }
        return CGSize(width: containerBounds.width / 3, height: 120)
    }
}
