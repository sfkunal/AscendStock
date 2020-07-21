

import UIKit

class WatchlistViewController: ATCGenericCollectionViewController {
    var uiConfig: ATCUIGenericConfigurationProtocol
    var dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider

        let layout = ATCCollectionViewFlowLayout()
        let config = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                     pullToRefreshTintColor: .white,
                                                                     collectionViewBackgroundColor: uiConfig.mainThemeBackgroundColor,
                                                                     collectionViewLayout: layout,
                                                                     collectionPagingEnabled: false,
                                                                     hideScrollIndicators: true,
                                                                     hidesNavigationBar: false,
                                                                     headerNibName: nil,
                                                                     scrollEnabled: false,
                                                                     uiConfig: uiConfig)
        super.init(configuration: config)

        // Fetching the watchlist from disk and setting it up as data source for the view contorller
        let store = ATCDiskPersistenceStore(key: "asset_watchlist")
        if let assets = store.retrieve() as? [ATCFinanceAsset] {
            self.genericDataSource = ATCGenericLocalDataSource(items: assets)
        } else {
            self.genericDataSource = ATCGenericLocalHeteroDataSource(items: [])
        }

        self.use(adapter: FinanceAssetRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAsset")
        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let stock = object as? ATCFinanceAsset {
                let vc = AssetDetailsViewController(asset: stock,
                                                    user: strongSelf.dsProvider.user,
                                                    uiConfig: strongSelf.uiConfig,
                                                    dsProvider: strongSelf.dsProvider)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.title = "Your Watchlist"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
