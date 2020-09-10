//
//  ATCClassicSignUpViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCClassicSignUpViewController: UIViewController, ATCSignUpScreenProtocol {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameTextField: ATCTextField!
    @IBOutlet var phoneNumberTextField: ATCTextField!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var emailTextField: ATCTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var textView: UITextView!

    weak var delegate: ATCSignUpScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.signUpScreenDidLoadView(self)
        let color = UIColor(hexString: "#00ff99")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        self.hideKeyboardWhenTappedAround()

        let linkedText = "Terms of Use"
        let string = "By creating an account you agree with our " + linkedText + "."
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link,
                                      value: "https://www.instamobile.io/eula-instachatty/",
                                      range: NSRange(location: string.count - 1 - linkedText.count, length: linkedText.count))
        textView.attributedText = attributedString
        textView.delegate = self
        textView.textColor = .gray
        textView.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ATCClassicSignUpViewController: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        //UIApplication.shared.open(URL, options: [:])
        let webView = ATCWebViewController(url: URL, title: "Terms of Use")
        self.navigationController?.pushViewController(webView, animated: true)
        return false
    }

    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let url = URL(string: "") {
            UIApplication.shared.open(url, options: [:])
        }
        return false
    }
}
