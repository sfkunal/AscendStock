


import UIKit

class ATCGridViewRowAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATCGridViewModel, let cell = cell as? ATCGridCollectionViewCell else { return }
        cell.configure(viewModel: viewModel, uiConfig: self.uiConfig)
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCGridCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCGridViewModel else { return .zero }
        return CGSize(width: containerBounds.width, height: viewModel.cellHeight)
    }
}
