

import UIKit

class ATCSquareStoryRowAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATCStoryViewModel, let cell = cell as? ATCSquareStoryCollectionViewCell else { return }
        cell.configure(uiConfig: uiConfig, viewModel: viewModel)
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCSquareStoryCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        return CGSize(width: 120, height: 125)
    }
}
