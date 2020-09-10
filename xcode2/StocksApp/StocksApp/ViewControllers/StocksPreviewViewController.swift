

import UIKit

class StocksPreviewViewController: ATCGenericCollectionViewController {
    var uiConfig: ATCUIGenericConfigurationProtocol
    var dsProvider: FinanceDataSourceProvider

    init(dsProvider: FinanceDataSourceProvider, uiConfig: ATCUIGenericConfigurationProtocol) {
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
        self.genericDataSource = dsProvider.stocksHomeDataSource
        self.use(adapter: CardHeaderRowAdapter(uiConfig: uiConfig), for: "CardHeaderModel")
        self.use(adapter: CardFooterRowAdapter(uiConfig: uiConfig), for: "CardFooterModel")
        self.use(adapter: FinanceAssetRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAsset")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let `self` = self else { return }
            if let footer = object as? CardFooterModel {
                let vc = StocksHomeViewController(uiConfig: self.uiConfig, dsProvider: self.dsProvider)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if let stock = object as? ATCFinanceAsset {
                let vc = AssetDetailsViewController(asset: stock,
                                                    user: self.dsProvider.user,
                                                    uiConfig: self.uiConfig,
                                                    dsProvider: self.dsProvider)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
