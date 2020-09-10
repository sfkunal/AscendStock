

import UIKit

class TransactionsViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider

    init(transactionDataSource: ATCGenericCollectionViewControllerDataSource,
         dsProvider: FinanceDataSourceProvider,
         scrollingEnabled: Bool,
         uiConfig: ATCUIGenericConfigurationProtocol) {
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
                                                                     scrollEnabled: scrollingEnabled,
                                                                     uiConfig: uiConfig)
        super.init(configuration: config)
        self.genericDataSource = transactionDataSource
        self.use(adapter: TransactionsRowAdapter(uiConfig: uiConfig), for: "ATCFinanceTransaction")
        self.title = "Transactions"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
