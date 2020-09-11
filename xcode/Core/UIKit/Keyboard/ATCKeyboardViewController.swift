

import UIKit

protocol ATCKeyboardViewControllerDelegate: class {
    func keyboardViewController(_ vc: ATCKeyboardViewController, didTap key: ATCKeyboardKey)
}

class ATCKeyboardViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let keys: [ATCKeyboardKey]

    weak var delegate: ATCKeyboardViewControllerDelegate?
    
    init(keys: [ATCKeyboardKey],
         uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
        self.keys = keys

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

        self.genericDataSource = ATCGenericLocalDataSource(items: keys)
        self.use(adapter: ATCKeyboardKeyRowAdapter(uiConfig: uiConfig), for: "ATCKeyboardKey")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let key = object as? ATCKeyboardKey {
                strongSelf.delegate?.keyboardViewController(strongSelf, didTap: key)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
