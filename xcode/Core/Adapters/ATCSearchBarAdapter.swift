

import UIKit

protocol ATCSearchBarAdapterDelegate: class {
    func searchAdapterDidFocus(_ adapter: ATCSearchBarAdapter)
}

class ATCSearchBarAdapter: NSObject, ATCGenericCollectionRowAdapter, UISearchBarDelegate {
    let uiConfig: ATCUIGenericConfigurationProtocol
    weak var delegate: ATCSearchBarAdapterDelegate?

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATCSearchBar, let cell = cell as? ATCSearchBarCollectionViewCell else { return }
        cell.searchBar.backgroundColor = .clear
        cell.searchBar.tintColor = UIColor(hexString: "#8e8d93")
        cell.searchBar.searchBarStyle = .minimal
        cell.searchBar.backgroundImage = nil

        cell.searchBar.placeholder = viewModel.placeholder
        cell.searchBar.delegate = self
        cell.setNeedsLayout()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCSearchBarCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard object is ATCSearchBar else { return .zero }
        return CGSize(width: containerBounds.width, height: 50)
    }

    // MARK: - UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.delegate?.searchAdapterDidFocus(self)
    }
}
