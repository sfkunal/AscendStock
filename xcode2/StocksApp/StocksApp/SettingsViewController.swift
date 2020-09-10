

import Eureka
import UIKit

class SettingsViewController: FormViewController {
    var user: ATCUser

    init(user: ATCUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapDone))
        self.title = "Settings"

        form +++ Eureka.Section("General Settings")
            <<< Eureka.SwitchRow() { row in
                row.title = "Allow Push Notifications"
                row.value = true
                row.tag = "pushnotifications"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "Notify on any transactions"
                row.value = false
                row.tag = "pushnotificationstransactions"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "Breaking news notifications"
                row.value = false
                row.tag = "pushnotificationsnews"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "Net worth milestones"
                row.value = false
                row.tag = "pushnotificationsnetworthmilestones"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "Allow Location Access"
                row.value = true
                row.tag = "location"
            }
            +++ Eureka.Section("Stocks Notifications")
            <<< Eureka.SwitchRow() { row in
                row.title = "Stocks drops of 5%"
                row.value = true
                row.tag = "pushnotificationsdropstocks"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "Stocks increases of 5%"
                row.value = false
                row.cellStyle = .subtitle
                row.tag = "pushnotificationsincreasestocks"
            }
            +++ Eureka.Section("Cryptocurrencies")
            <<< Eureka.SwitchRow() { row in
                row.title = "Crypto drops of 5%"
                row.value = true
                row.tag = "pushnotificationsdropcrypto"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "Crypto increases of 5%"
                row.value = true
                row.tag = "pushnotificationsincreasecrypto"
            }
            +++ Eureka.Section("News Notifications")
            <<< Eureka.SwitchRow() { row in
                row.title = "News on watchlist stocks"
                row.value = true
                row.tag = "newswatchlist"
            }
            <<< Eureka.SwitchRow() { row in
                row.title = "News on watchlist cryptos"
                row.value = true
                row.tag = "newscryptos"
        }
    }

    @objc private func didTapDone() {
    }

    @objc private func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
