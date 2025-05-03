//
//  AppConstants.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation
import UIKit

let isTestMode = true
let popupStoryBoard = UIStoryboard(name: "PopUpStoryBoard", bundle: nil)

class ApiConstants {
    static let allDecksApiUrl = "https://jsonblob.com/api/1275682516793942016"
    // static let localeDecksApiUrl = "https://jsonblob.com/api/1320619828859559936"
    static let appDetailsApiUrl = "https://jsonblob.com/api/1273995319376207872"
}

class AppConstants {
    static let appName = "Charades"
    static let appSharedSecret = "0ff01b71411848508ae676bd50105b1a"
    static let appUrl = "https://apps.apple.com/app/id1234567890"
    static let termsOfUseUrl = "https://www.google.com/"
    static let mailId = "recipient@example.com"
    static let privacyPolicyUrl = "https://www.google.com/"
    static let appRateUrl = "https://apps.apple.com/app/id1234567890?action=write-review"
    static let offerDuration = TimeInterval(15 * 60)
    static let offerCountDown = Double(120)
    static let discount = 0.90
}

class FontStyle {
    static let regular = "LeagueSpartan-Regular"
    static let thin = "LeagueSpartan-Thin"
    static let extraLight = "LeagueSpartan-ExtraLight"
    static let light = "LeagueSpartan-Light"
    static let medium = "LeagueSpartan-Medium"
    static let semiBold = "LeagueSpartan-SemiBold"
    static let bold = "LeagueSpartan-Bold"
    static let extraBold = "LeagueSpartan-ExtraBold"
    static let black = "LeagueSpartan-Black"
}
