

import UIKit

class BankAccountsViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider
        let layout = ATCLiquidCollectionViewLayout()
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

        self.genericDataSource = dsProvider.bankAccountsDataSource
        self.use(adapter: CardHeaderRowAdapter(uiConfig: uiConfig), for: "CardHeaderModel")
        self.use(adapter: FinanceAccountRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAccount")

        let adapter = AddBankAccountButtonRowAdapter(uiConfig: uiConfig)
        adapter.delegate = self
        self.use(adapter: adapter, for: "AddBankAccountModel")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let account = object as? ATCFinanceAccount {
                // nothing to do here
            }
        }
        self.title = "Your Financial Accounts"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BankAccountsViewController: AddBankAccountButtonRowAdapterDelegate {
    func rowAdapterDidTapButton(_ rowAdapter: AddBankAccountButtonRowAdapter) {
        let vc = FinanceAddInstitutionViewController(uiConfig: uiConfig, dsProvider: dsProvider)
        let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
