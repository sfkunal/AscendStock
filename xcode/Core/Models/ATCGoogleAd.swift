

import GoogleMobileAds
import UIKit

class ATCGoogleAd: ATCGenericBaseModel {
    var description: String {
        return ""
    }

    let googleAdRequest = GADRequest()

    init() {}
    required init(jsonDict: [String: Any]) {}
}
