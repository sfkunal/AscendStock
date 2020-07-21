//
//  ATCSettingsContactUsViewController.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//
//
//

import UIKit

class ATCSettingsContactUsViewController: QuickTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"

        tableContents = [
            Section(title: "Contact", rows: [
                NavigationRow(text: "Our address", detailText: .subtitle("1412 Steiner Street, San Fracisco, CA, 94115"), icon: .named("globe")),
                NavigationRow(text: "E-mail us", detailText: .value1("office@shopertino.com"), icon: .named("time"), action: { _ in })
                ], footer: "Our business hours are Mon - Fri, 10am - 5pm, PST."),
            Section(title: "", rows: [
                TapActionRow(text: "Call Us", action: { (row) in
                    guard let number = URL(string: "tel://6504859694") else { return }
                    UIApplication.shared.open(number)
                })
                ]),
        ]
    }

    // MARK: - Actions
    private func showAlert(_ sender: Row) {
        // ...
    }

    private func didToggleSelection() -> (Row) -> Void {
        return {row in
            // ...
        }
    }

}
