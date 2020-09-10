

import UIKit

class FinanceNotificationsViewController: ATCGenericCollectionViewController {
    var uiConfig: ATCUIGenericConfigurationProtocol
    var dsProvider: FinanceDataSourceProvider

    init(dsProvider: FinanceDataSourceProvider, uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider

        let layout = ATCLiquidCollectionViewLayout()
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
        self.genericDataSource = dsProvider.notificationsDataSource()
        self.use(adapter: FinanceNotificationRowAdapter(uiConfig: uiConfig), for: "ATCNotification")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard self != nil else { return }
            if object is ATCNotification {
            }
        }
        self.title = "Notifications"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

