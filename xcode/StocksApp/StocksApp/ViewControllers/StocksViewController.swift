

import UIKit

class StocksViewController: ATCGenericCollectionViewController {
    var uiConfig: ATCUIGenericConfigurationProtocol
    var dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider,
         dataSource: ATCGenericCollectionViewControllerDataSource) {
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
        self.genericDataSource = dataSource
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
