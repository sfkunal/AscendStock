

import UIKit

class AssetSearchViewController: ATCGenericSearchViewController<ATCFinanceAsset> {
    init(uiConfig: ATCUIGenericConfigurationProtocol,
         searchDataSource: ATCGenericSearchViewControllerDataSource,
         dsProvider: FinanceDataSourceProvider,
         title: String) {
        super.init(configuration: ATCGenericSearchViewControllerConfiguration(searchBarPlaceholderText: title, uiConfig: uiConfig, cellPadding: 0))
        self.searchDataSource = searchDataSource
        self.use(adapter: FinanceAssetRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAsset")
        self.searchResultsController.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let `self` = self else { return }
            if let asset = object as? ATCFinanceAsset {
                let vc = AssetDetailsViewController(asset: asset,
                                                    user: dsProvider.user,
                                                    uiConfig: uiConfig,
                                                    dsProvider: dsProvider)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.cancelBlock = { () in
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.becomeFirstResponder()
        self.navigationController?.navigationBar.topItem?.title = ""
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
