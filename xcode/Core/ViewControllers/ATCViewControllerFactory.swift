//
//  ATCViewControllerFactory.swift
//  RestaurantApp
//
//  Created by Florian Marcu on 5/15/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit

class ATCViewControllerFactory {

    static func storiesViewController(dataSource: ATCGenericCollectionViewControllerDataSource,
                                      uiConfig: ATCUIGenericConfigurationProtocol,
                                      minimumInteritemSpacing: CGFloat = 0,
                                      selectionBlock: ATCollectionViewSelectionBlock?) -> ATCGenericCollectionViewController {
        let layout = ATCCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumInteritemSpacing
        let configuration = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                            pullToRefreshTintColor: .white,
                                                                            collectionViewBackgroundColor: .white,
                                                                            collectionViewLayout: layout,
                                                                            collectionPagingEnabled: false,
                                                                            hideScrollIndicators: true,
                                                                            hidesNavigationBar: false,
                                                                            headerNibName: nil,
                                                                            scrollEnabled: true,
                                                                            uiConfig: uiConfig)
        let vc = ATCGenericCollectionViewController(configuration: configuration, selectionBlock: selectionBlock)
        // vc.genericDataSource = ATCGenericLocalDataSource<ATCStoryViewModel>(items: stories)
        vc.genericDataSource = dataSource

        return vc
    }

//    static func createContactUsViewController(viewModel: ATCContactUsViewModel, uiTheme: ATCContactUsUITheme) -> UIViewController {
//        return ATCContactUsViewController(viewModel: viewModel, uiTheme: uiTheme, nibName: "ATCContactUsView", bundle: nil)
//    }
}
