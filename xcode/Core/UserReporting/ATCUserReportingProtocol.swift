//
//  ATCUserReportingProtocol.swift
//  DatingApp
//
//  Created by Florian Marcu on 4/10/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

let kUserReportingDidUpdateNotificationName = NSNotification.Name(rawValue: "kUserReportingDidUpdateNotificationName")

enum ATCReportingReason: String {
    case sensitiveImages
    case spam
    case abusive
    case harmful

    var rawValue: String {
        switch self {
        case .sensitiveImages: return "sensitiveImages"
        case .spam: return "spam"
        case .abusive: return "abusive"
        case .harmful: return "harmful"
        }
    }
}

protocol ATCUserReportingProtocol: class {
    func report(sourceUser: ATCUser, destUser: ATCUser, reason: ATCReportingReason, completion: @escaping (_ success: Bool) -> Void)
    func block(sourceUser: ATCUser, destUser: ATCUser, completion: @escaping (_ success: Bool) -> Void)
    func userIDsBlockedOrReported(by user: ATCUser, completion: @escaping (_ users: Set<String>) -> Void)
}
