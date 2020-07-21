

import UIKit

class FinanceAddInstitutionViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider
        let layout = ATCLiquidCollectionViewLayout(cellPadding: 10)
        let config = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
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

        self.genericDataSource = dsProvider.institutionsDataSource
        self.use(adapter: FinanceInstitutionRowAdapter(uiConfig: uiConfig), for: "ATCFinanceInstitution")
//        self.use(adapter: ATCDividerRowAdapter(titleFont: uiConfig.regularFont(size: 12)), for: "ATCDivider")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let institution = object as? ATCFinanceInstitution {
                // code to handle linking a new institution institution
                // we are just dismissing the screen for now
                strongSelf.didTapDone()
            }
        }
        self.title = "Link New Account"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
    }

    @objc private func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
}
