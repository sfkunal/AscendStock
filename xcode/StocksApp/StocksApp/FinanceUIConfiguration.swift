

import UIKit

class FinanceUIConfiguration: ATCUIGenericConfigurationProtocol, ATCOnboardingServerConfigurationProtocol {
    let mainThemeBackgroundColor: UIColor = .white
    let mainThemeForegroundColor: UIColor = UIColor(hexString: "#00ff99")
    let mainTextColor: UIColor = UIColor(hexString: "#070f12")
    let mainSubtextColor: UIColor = UIColor(hexString: "#768695")
    let statusBarStyle: UIStatusBarStyle = .lightContent
    let hairlineColor: UIColor = UIColor(hexString: "#d6d6d6", alpha: 0.4)

    let regularSmallFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
    let regularMediumFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
    let regularLargeFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)!
    let mediumBoldFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!
    let boldLargeFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)!
    let boldSmallFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)!
    let boldSuperSmallFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)!
    let boldSuperLargeFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 28)!

    let italicMediumFont = UIFont(name: "TrebuchetMS-Italic", size: 14)!

    let homeImage = UIImage.localImage("home-icon", template: true)
    let expensesImage = UIImage.localImage("expenses-pie-icon", template: true)
    // let accountsImage = UIImage.localImage("accounts-list-icon", template: true)
    let portfolioImage = UIImage.localImage("money-bag-empty-icon", template: true)
    let notificationsImage = UIImage.localImage("bell-icon", template: true)
    let profileImage = UIImage.localImage("profile-male-icon", template: true)
    let newsImage = UIImage.localImage("news-icon", template: true)
    let settingsImage = UIImage.localImage("settings-menu-item", template: true)

    func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
    }

    func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: size)!
    }

    func configureUI() {
        UITabBar.appearance().barTintColor = self.mainThemeBackgroundColor
        UITabBar.appearance().tintColor = self.mainThemeForegroundColor
        UITabBar.appearance().unselectedItemTintColor = UIColor(hexString: "#a2a2a2")
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor(hexString: "#a2a2a2"),
                                                          .font: self.boldSuperSmallFont],
                                                         for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : self.mainThemeForegroundColor,
                                                          .font: self.boldSuperSmallFont],
                                                         for: .selected)

        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(self.mainThemeBackgroundColor)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(self.hairlineColor)

        UINavigationBar.appearance().barTintColor = self.mainThemeForegroundColor
        UINavigationBar.appearance().tintColor = self.mainThemeBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.mainThemeBackgroundColor]
        //        UINavigationBar.appearance().isTranslucent = false
        //
        //        UITabBar.appearance().tintColor = ATCUIConfiguration.shared.mainThemeColor
        //        UITabBar.appearance().barTintColor = ATCUIConfiguration.shared.tabBarBarTintColor
        //        if #available(iOS 10.0, *) {
        //            UITabBar.appearance().unselectedItemTintColor = ATCUIConfiguration.shared.mainThemeColor
        //        }
    }

    var isFirebaseAuthEnabled: Bool {
        return true
    }

    var appIdentifier: String {
        return "Finance - iOSAppTemplates"
    }
}
