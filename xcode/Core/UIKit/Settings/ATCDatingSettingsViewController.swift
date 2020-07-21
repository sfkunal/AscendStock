//
//  ATCSettingsViewController.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCDatingSettingsViewController: QuickTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"

        tableContents = [
            Section(title: "Discovery", rows: [
                SwitchRow(text: "Show me on Tinder", switchValue: true, action: { _ in }),
                ], footer: "While turned off, you will not be shown in the card stack. You can still see and chat with your matches."),
            Section(title: "Push Notifications", rows: [
                SwitchRow(text: "New Matches", switchValue: true, action: { _ in }),
                SwitchRow(text: "Messages", switchValue: false, action: { _ in }),
                SwitchRow(text: "Super Likes", switchValue: true, action: { _ in }),
                SwitchRow(text: "Top Picks", switchValue: false, action: { _ in }),
                ]),
            RadioSection(title: "Gender", options: [
                OptionRow(text: "Female", isSelected: true, action: didToggleSelection()),
                OptionRow(text: "Male", isSelected: false, action: didToggleSelection()),
                OptionRow(text: "Don't show", isSelected: false, action: didToggleSelection())
                ], footer: "You will get recommendations based on your gender."),
            RadioSection(title: "Maximum Distance", options: [
                OptionRow(text: "5 miles", isSelected: true, action: didToggleSelection()),
                OptionRow(text: "10 miles", isSelected: false, action: didToggleSelection()),
                OptionRow(text: "20 miles", isSelected: false, action: didToggleSelection()),
                OptionRow(text: "50 miles", isSelected: false, action: didToggleSelection())
                ], footer: "You will recommendations in this area."),
            Section(title: "Account", rows: [
                TapActionRow(text: "Support", action: { [weak self] in self?.showAlert($0) }),
                TapActionRow(text: "Log Out", action: { (row) in
                    NotificationCenter.default.post(name: kLogoutNotificationName, object: nil)
                })
                ]),
        ]
    }

    // MARK: - Actions
    private func showAlert(_ sender: Row) {
        // ...
    }

    private func didToggleSelection() -> (Row) -> Void {
        return { row in
            // ...
        }
    }
}
