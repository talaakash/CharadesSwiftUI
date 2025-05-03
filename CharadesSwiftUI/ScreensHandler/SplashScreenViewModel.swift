//
//  SplashScreenViewModel.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation
import SwiftUICore

class SplashScreenViewModel: ObservableObject {
    
    private var dataUpdatedVersion: String = ""
    private var isRecieptVerified: Bool = false {
        didSet {
            self.checkAllTaskIsDone()
        }
    }
    private var versionCheckDone: Bool = false {
        didSet {
            self.checkAllTaskIsDone()
        }
    }
    
    init() {
        self.doInitWork()
    }
    
    func doInitWork() {
        NetworkManager.shared.startMonitor { isNetworkAvailable in
            if isNetworkAvailable {
                IAPManager.shared.getActivePlan(success: { _ in
                    UserManager.shared.setUserType(type: .paid)
                    self.isRecieptVerified = true
                }, failure: { _ in
                    self.isRecieptVerified = true
                })
                self.checkForAppVersionUpdate()
            } else {
                
            }
        }
    }
}

// MARK: Private Methods
extension SplashScreenViewModel {
    private func checkForAppVersionUpdate() {
        ApiManager.shared.makeApiCall(url: ApiConstants.appDetailsApiUrl, method: .get, success: { json in
            DispatchQueue.main.async {
                if let json = UtilityManager.shared.findValueInJson(type: [String: Any].self, key: "iOS", json: json as? [String : Any] ?? [:]) {
                    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    if let remoteVersion = json["force_update_version"] as? Double, let appUrl = URL(string: AppConstants.appUrl), let currentVersion = Double(currentVersion ?? "") {
                        if currentVersion >= remoteVersion {
                            self.checkForDataVersion()
                        } else {
//                            UIApplication.shared.open(appUrl)
                            debugPrint(appUrl.absoluteString)
//                            let alertController = UIAlertController(title: AppConstants.appName.localize(), message: json["description"] as? String, preferredStyle: .alert)
//                            let updateApp = UIAlertAction(title: json["button_title"] as? String, style: .default, handler: { _ in
//                                UIApplication.shared.open(appUrl)
//                            })
//                            alertController.addAction(updateApp)
//                            self.present(alertController, animated: true)
                        }
                    } else {
                        self.showVersionCheckFailure()
                    }
                } else {
                    self.showVersionCheckFailure()
                }
            }
        }, failure: { error in
            debugPrint("Error: \(error)")
            DispatchQueue.main.async {
                self.showVersionCheckFailure()
            }
        })
    }
    
    private func checkForDataVersion() {
        FirebaseRemoteConfigManager.shared.fetchRemoteConfig(completion: { isLoaded in
            if isLoaded {
                FirebaseRemoteConfigManager.shared.isPromotionOn = FirebaseRemoteConfigManager.shared.getBool(forKey: "isPromotionOn")
                IAPManager.shared.allPlan = FirebaseRemoteConfigManager.shared.getValue(type: [Plan].self, key: "all_plan_info")
                FirebaseRemoteConfigManager.shared.flatDuration = FirebaseRemoteConfigManager.shared.getInt(forKey: "flatDuration")
                FirebaseRemoteConfigManager.shared.promotedAppID = FirebaseRemoteConfigManager.shared.getString(forKey: "promoted_app")
                self.getAllPlanFromApple()
                if let appData = FirebaseRemoteConfigManager.shared.getValue(forKey: "app_data") as? [String: String], let dataVersion = appData["dataVersion"] {
                    self.dataUpdatedVersion = dataVersion
                    if let currentDataVersion = UserDefaults.standard.value(forKey: UserManager.shared.getApiVersionKey()) as? String {
                        if currentDataVersion != dataVersion {
                            self.loadAllData(from: appData)
                        } else {
                            self.versionCheckDone = true
                        }
                    } else {
                        self.loadAllData(from: appData)
                    }
                } else {
                    self.showDownloadFailureAlert()
                }
            } else {
                self.showDownloadFailureAlert()
            }
        })
    }
    
    private func loadAllData(from json: [String: String]) {
        var localeDeck: [[String: Any]] = [] {
            didSet {
                if !allDecks.isEmpty {
                    self.filterDataAndStore(allDecks: &allDecks, localeDecks: localeDeck)
                }
            }
        }
        var allDecks: [[String: Any]] = [] {
            didSet {
                if !localeDeck.isEmpty || !isLocaleAvailable {
                    self.filterDataAndStore(allDecks: &allDecks, localeDecks: localeDeck)
                }
            }
        }
        var isLocaleAvailable: Bool = true
        
        if let allDeckApiEndpoint = json["default"] {
            let countryLocale = UtilityManager.shared.getLocaleCountryCode() ?? ""
            if !json.keys.contains(countryLocale) {
                isLocaleAvailable = false
            }
            if isLocaleAvailable, let localeEndPoint = json[countryLocale] {
                self.loadDataFromApi(url: localeEndPoint, success: { data in
                    localeDeck = data
                })
            } else {
                isLocaleAvailable = false
            }
            self.loadDataFromApi(url: allDeckApiEndpoint, success: { data in
                allDecks = data
            })
        } else {
            self.showDownloadFailureAlert()
        }
    }

    private func filterDataAndStore(allDecks: inout [[String: Any]], localeDecks: [[String: Any]]) {
        let localeIds = Set(localeDecks.compactMap { $0["id"] as? Int })
        allDecks = allDecks.filter { json in
            guard let id = json["id"] as? Int else { return true }
            return !localeIds.contains(id)
        }
        
        if localeDecks.isEmpty && StorageManager.shared.storeJson(typeOfJson: .allDecks, json: allDecks) {
            UserDefaults.standard.set(self.dataUpdatedVersion, forKey: UserManager.shared.getApiVersionKey())
            self.versionCheckDone = true
        } else if StorageManager.shared.storeJson(typeOfJson: .allDecks, json: allDecks), StorageManager.shared.storeJson(typeOfJson: .localDeck, json: localeDecks) {
            UserDefaults.standard.set(self.dataUpdatedVersion, forKey: UserManager.shared.getApiVersionKey())
            self.versionCheckDone = true
        } else {
            self.showDownloadFailureAlert()
        }
    }
    
    private func loadDataFromApi(url: String, success: @escaping ([[String: Any]]) -> Void) {
        ApiManager.shared.makeApiCall(url: url, method: .get, success: { json in
            if let json = json as? [[String: Any]] {
                success(json)
            } else {
                self.showDownloadFailureAlert()
            }
        }, failure: { error in
            self.showDownloadFailureAlert()
        })
    }
    
    private func showVersionCheckFailure() {
        
    }
    
    private func showDownloadFailureAlert() {
        
    }
    
    private func getAllPlanFromApple() {
        IAPManager.shared.loadAllPlan()
    }
    
    private func checkAllTaskIsDone() {
        if self.isRecieptVerified && self.versionCheckDone {
            DispatchQueue.main.async {
                setRootView(HomeScreen())
            }
        }
    }
}
