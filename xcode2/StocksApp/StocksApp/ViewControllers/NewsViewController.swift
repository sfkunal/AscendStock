

import UIKit

class NewsViewController: ATCGenericCollectionViewController {
    var uiConfig: ATCUIGenericConfigurationProtocol
    var dsProvider: FinanceDataSourceProvider

    init(dsProvider: FinanceDataSourceProvider, uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider

        let layout = ATCCollectionViewFlowLayout()
        let config = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: true,
                                                                     pullToRefreshTintColor: .white,
                                                                     collectionViewBackgroundColor: uiConfig.mainThemeBackgroundColor,
                                                                     collectionViewLayout: layout,
                                                                     collectionPagingEnabled: false,
                                                                     hideScrollIndicators: true,
                                                                     hidesNavigationBar: false,
                                                                     headerNibName: nil,
                                                                     scrollEnabled: true,
                                                                     uiConfig: uiConfig)
        super.init(configuration: config)
        self.genericDataSource = dsProvider.allNewsDataSource
        self.use(adapter: FinanceNewsRowAdapter(uiConfig: uiConfig), for: "ATCFinanceNewsModel")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let news = object as? ATCFinanceNewsModel {
                if let url = URL(string: news.url) {
                    let vc = ATCWebViewController(url: url, title: news.publication)
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        self.title = "Market News"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

