

import UIKit

class AssetTradingViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var formContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var firstBorderView: UIView!
    @IBOutlet var marketPriceTitleLabel: UILabel!
    @IBOutlet var crossLabel: UILabel!
    @IBOutlet var marketPriceLabel: UILabel!
    @IBOutlet var estCreditTitleLabel: UILabel!
    @IBOutlet var secondBorderView: UIView!
    @IBOutlet var estCreditLabel: UILabel!
    @IBOutlet var keyboardContainerView: UIView!
    @IBOutlet var tradeButton: UIButton!

    let asset: ATCFinanceAsset
    let keyboardViewController: ATCKeyboardViewController
    let uiConfig: ATCUIGenericConfigurationProtocol

    init(asset: ATCFinanceAsset,
         title: String,
         keys: [ATCKeyboardKey],
         uiConfig: ATCUIGenericConfigurationProtocol) {
        self.asset = asset
        self.uiConfig = uiConfig
        keyboardViewController = ATCKeyboardViewController(keys: keys,
                                                           uiConfig: uiConfig)
        super.init(nibName: "AssetTradingViewController", bundle: nil)
        keyboardViewController.delegate = self

        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        self.addChildViewControllerWithView(keyboardViewController, toView: keyboardContainerView)

        titleLabel.text = "Shares of \(asset.ticker)".uppercased()
        titleLabel.textColor = uiConfig.mainThemeForegroundColor
        titleLabel.font = uiConfig.boldFont(size: 14)

        numberTextField.placeholder = "0"
        numberTextField.font = uiConfig.regularFont(size: 24)
        numberTextField.backgroundColor = .clear
        numberTextField.textColor = uiConfig.mainThemeForegroundColor
        numberTextField.inputView = UIView()

        marketPriceTitleLabel.text = "MKT Price".uppercased()
        marketPriceTitleLabel.textColor = uiConfig.mainThemeForegroundColor
        marketPriceTitleLabel.font = uiConfig.boldFont(size: 14)

        crossLabel.text = "\u{00D7}".uppercased()
        crossLabel.textColor = uiConfig.mainSubtextColor
        crossLabel.font = uiConfig.regularFont(size: 20)

        marketPriceLabel.text = asset.price.uppercased()
        marketPriceLabel.textColor = uiConfig.mainTextColor
        marketPriceLabel.font = uiConfig.regularFont(size: 18)

        estCreditTitleLabel.text = "EST Credit".uppercased()
        estCreditTitleLabel.textColor = uiConfig.mainSubtextColor
        estCreditTitleLabel.font = uiConfig.boldFont(size: 14)

        estCreditLabel.textColor = uiConfig.mainTextColor
        estCreditLabel.font = uiConfig.boldFont(size: 18)
        tradeButton.alpha = 0
        self.updateLabels()

        tradeButton.configure(color: uiConfig.mainThemeBackgroundColor,
                              font: uiConfig.regularFont(size: 16),
                              cornerRadius: 7,
                              borderColor: nil,
                              backgroundColor: uiConfig.mainThemeForegroundColor,
                              borderWidth: nil)
        tradeButton.setTitle("Trade", for: .normal)
        tradeButton.addTarget(self, action: #selector(didTapTradeButton), for: .touchUpInside)
        firstBorderView.backgroundColor = uiConfig.hairlineColor
        secondBorderView.backgroundColor = uiConfig.hairlineColor
    }

    fileprivate func updateLabels() {
        estCreditLabel.text = currentCreditString.uppercased()
        let alpha: CGFloat = (self.currentCredit == 0.0) ? 0.0 : 1.0
        UIView.animate(withDuration: 0.3) {
            self.tradeButton.alpha = alpha
        }
    }

    private var currentCreditString: String {
        return "$" + String(currentCredit)
    }

    private var currentCredit: Double {
        let assetPrice = asset.price.replacingOccurrences(of: "$", with: "")
        return (Double(numberTextField.text ?? "0") ?? 0) * (Double(assetPrice) ?? 0)
    }

    @objc private func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapTradeButton() {
        // Add code for trading here
        // For now, we just dismiss the screen
        self.dismiss(animated: true, completion: nil)
    }
}

extension AssetTradingViewController: ATCKeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: ATCKeyboardViewController, didTap key: ATCKeyboardKey) {
        if key.value == backArrowUnicode {
            numberTextField.text = String(numberTextField.text?.dropLast() ?? "")
        } else {
            if key.value != "0" || (numberTextField.text?.count ?? 0) > 0 {
                numberTextField.text = (numberTextField.text ?? "") + key.value
            }
        }
        numberTextField.setNeedsLayout()
        numberTextField.layoutIfNeeded()
        updateLabels()
    }
}
