//
//  ATCFinanceContactUsViewController.swift
//  CryptoApp
//
//  Created by Florian Marcu on 6/29/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCFinanceContactUsViewController: QuickTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableContents = [
            Section(title: "Contact", rows: [
                NavigationRow(text: "Our address", detailText: .subtitle(""), icon: .named("globe")),
                NavigationRow(text: "E-mail us", detailText: .value1("kunal@masagroup.com"), icon: .named("time"), action: { (row) in
                    guard let email = URL(string: "mailto:kunal@masagroup.com") else { return }
                    UIApplication.shared.open(email)
                })
                ], footer: "Our business hours are Mon - Fri, 10am - 5pm, PST."),
            Section(title: "", rows: [
                TapActionRow(text: "Call Us", action: { (row) in
                    guard let number = URL(string: "tel://6502292554") else { return }
                    UIApplication.shared.open(number)
                })
                ]),
        ]

        self.title = "Contact Us"
    }

    // MARK: - Actions
    private func showAlert(_ sender: Row) {
        // ...
    }

    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] row in
            // ...
        }
    }
}
