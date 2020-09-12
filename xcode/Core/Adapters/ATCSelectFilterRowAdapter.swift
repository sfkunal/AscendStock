

import UIKit

class ATCSelectFilterRowAdapter: ATCGenericCollectionRowAdapter {
    let titleFont: UIFont?
    let optionFont: UIFont?
    let titleColor: UIColor
    var height: CGFloat

    init(titleFont: UIFont? = nil,
         titleColor: UIColor = UIColor(hexString: "#343d52"),
         optionFont: UIFont? = nil,
         height: CGFloat = 70) {
        self.titleFont = titleFont
        self.optionFont = optionFont
        self.height = height
        self.titleColor = titleColor
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let filter = object as? ATCSelectFilter, let cell = cell as? ATCSelectFilterCollectionViewCell {
            cell.filterNameLabel.text = filter.title
            cell.selectedOptionLabel.text = filter.selectedOption?.name
            cell.cellContainerView.addBorder(side: .bottom, thickness: 1, color: UIColor(hexString: "#e6e6e6"))
            cell.filterNameLabel.textColor = self.titleColor
            cell.selectedOptionLabel.textColor = .gray
            if let titleFont = titleFont {
                cell.filterNameLabel.font = titleFont
            }
            if let optionFont = optionFont {
                cell.selectedOptionLabel.font = optionFont
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCSelectFilterCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        return CGSize(width: containerBounds.width, height: height)
    }
}
