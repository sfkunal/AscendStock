//
//  ATCProfileButtonItemRowAdapter.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCProfileButtonItemRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATCProfileButtonItem, let cell = cell as? ATCProfileButtonCollectionViewCell else { return }
        cell.button.setTitle(viewModel.title, for: .normal)
        cell.button.configure(tintColor: viewModel.textColor ?? .white,
                              font: uiConfig.boldFont(size: 18.0),
                              bgColor: viewModel.color ?? .white,
                              borderColor: .clear,
                              borderWidth: 0.0,
                              cornerRadius: 8)
        cell.button.isUserInteractionEnabled = false
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCProfileButtonCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let _ = object as? ATCProfileButtonItem else { return .zero }
        return CGSize(width: containerBounds.width, height: 65.0)
    }
}
