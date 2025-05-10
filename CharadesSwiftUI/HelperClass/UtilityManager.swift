//
//  UtilityManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//


import Foundation
import UIKit
import MessageUI

class UtilityManager: NSObject {
    static let shared = UtilityManager()
    private override init() { }
    
    
    func shareApp() {
        let appShareMessage = [String(format: "appShareMessage".localize(), AppConstants.appName.localize(), AppConstants.appName.localize(), AppConstants.appUrl)]
        let activityVC = UIActivityViewController(activityItems: appShareMessage, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        if let topController = UIApplication.shared.topMostViewController() {
            topController.present(activityVC, animated: true)
        }
    }
    
    func sendContactUsEmail() {
        guard let topController = UIApplication.shared.topMostViewController() else { return }
        guard MFMailComposeViewController.canSendMail() else {
            let alertController = UIAlertController(title: "appName".localize(), message: "mailOpenFail".localize(), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "buttonTitleOkay".localize(), style: .default, handler: nil)
            alertController.addAction(okAction)
            topController.present(alertController, animated: true, completion: nil)
            return
        }
        let mailComposeViewController = configuredMailComposeViewController()
        topController.present(mailComposeViewController, animated: true)
    }
    
    func getLocaleCountryCode() -> String? {
        let preferredLanguage = Locale.preferredLanguages.first?.split(separator: "-").first?.lowercased() ?? "en"
        return preferredLanguage
    }
    
    func findValueInJson<T>(type: T.Type, key: String, json: [String: Any]) -> T? {
        for id in json.keys{
            if id == key, let value = json[id] as? T {
                return value
            } else if let innerJson = json[id] as? [String: Any] {
                let result = findValueInJson(type: type, key: key, json: innerJson)
                if let result {
                    return result
                }
            }
        }
        return nil
    }
}

// MARK: Private methods
extension UtilityManager {
    
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self

        mailComposeVC.setToRecipients([AppConstants.mailId])
        mailComposeVC.setSubject("\("appName".localize()) \("mailSubject".localize())")
        
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            appVersion = version
        }
        let messageBody = String(format: "mailMessage".localize(), "appName".localize(), "\(UIDevice.current.systemVersion)", appVersion)
        
        mailComposeVC.setMessageBody(messageBody, isHTML: false)

        return mailComposeVC
    }
}

extension UtilityManager: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            debugPrint("Mail cancelled")
        case .saved:
            debugPrint("Mail saved")
        case .sent:
            debugPrint("Mail sent")
        case .failed:
            debugPrint("Mail sent failure: \(String(describing: error?.localizedDescription))")
        @unknown default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController,
           let selected = tab.selectedViewController {
            return topMostViewController(base: selected)
        }

        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }

        return base
    }
}
