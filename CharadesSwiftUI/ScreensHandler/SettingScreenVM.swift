//
//  SettingScreenVM.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 04/05/25.
//

import Foundation
import SwiftUI

enum Settings: CaseIterable {
    case control, howToPlay, rateUs, contactUs, shareApp
}

struct SettingOptions: Hashable {
    var icon: UIImage
    var name: String
    var type: Settings
    
    init(icon: UIImage, name: String, type: Settings) {
        self.icon = icon
        self.name = name
        self.type = type
    }
}

class SettingScreenVM: ObservableObject {
    @AppStorage("isGyroControllerOn") var isGyroOn: Bool = true {
        didSet {
            settingOptions = settingOptions.map { option in
                var modifiedOption = option
                if modifiedOption.type == .control {
                    if isGyroOn {
                        modifiedOption.icon = UIImage.tilt
                        modifiedOption.name = "gyroControl".localize()
                    } else {
                        modifiedOption.icon = UIImage.tap
                        modifiedOption.name = "tapControl".localize()
                    }
                }
                return modifiedOption
            }
        }
    }
    @Published var settingOptions = [
        SettingOptions(icon: UIImage.tilt, name: "gyroControl".localize(), type: .control),
        SettingOptions(icon: UIImage.howToPlay, name: "howToPlaySetting".localize(), type: .howToPlay),
        SettingOptions(icon: UIImage.rate, name: "rateUsSetting".localize(), type: .rateUs),
        SettingOptions(icon: UIImage.contactUs, name: "contactUsSetting".localize(), type: .contactUs),
        SettingOptions(icon: UIImage.share, name: "shareAppSetting".localize(), type: .shareApp)
    ]
    @Published var howToPlay = false
    
    func selected(option: SettingOptions) {
        switch option.type {
        case .control:
            self.isGyroOn.toggle()
            if isGyroOn {
                ToastManager.shared.showToast(message: "tiltControlMsg".localize())
            } else {
                ToastManager.shared.showToast(message: "tapControlMsg".localize())
            }
        case .howToPlay:
            howToPlay = true
        case .rateUs:
            if let url = URL(string: AppConstants.appRateUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .contactUs:
            UtilityManager.shared.sendContactUsEmail()
        case .shareApp:
            UtilityManager.shared.shareApp()
        }
    }
}
