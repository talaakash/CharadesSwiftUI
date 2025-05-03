//
//  RemoteConfigManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation
import FirebaseRemoteConfig
import StoreKit

struct Plan: Codable {
    let planDisplayName: String
    let planType: String
    let isOffer: Bool
    let planDuration: String
    let planId: String
    let isActive: Bool
    var isDefaultSelected:Bool
    let tag:String

    // StoreKit 2 Product (Not Codable, assigned later)
    var planProduct: Product?

    // CodingKeys to match JSON keys with struct properties
    enum CodingKeys: String, CodingKey {
        case planDisplayName = "plan_display_name"
        case planType = "plan_type"
        case isOffer = "is_offer"
        case planDuration = "plan_duration"
        case planId = "plan_id"
        case isActive = "is_active"
        case isDefaultSelected = "is_default_selected"
        case tag = "tag"
    }
}

class FirebaseRemoteConfigManager {
    static let shared = FirebaseRemoteConfigManager()
    private var remoteConfig: RemoteConfig!
    
    var allDecks: [Deck]? = []
    var localeDeck: [Deck]? = []
    
    var isPromotionOn = false
    var flatDuration = 0
    var promotedAppID = ""

    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = isTestMode ? 0 : 3600  // Fetch interval in seconds
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }

    func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
        remoteConfig.fetch { status, error in
            if status == .success {
                self.remoteConfig.activate { changed, error in
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func getValue<T : Decodable>(type: T.Type, key: String) -> T?{
        let remoteConfigData = remoteConfig.configValue(forKey: key).dataValue
        let json = try? JSONDecoder().decode(type.self, from: remoteConfigData)
        return json
    }
    
    func getString(forKey key: String) -> String{
        return remoteConfig.configValue(forKey: key).stringValue
    }
    
    func getBool(forKey key: String) -> Bool{
        return remoteConfig.configValue(forKey: key).boolValue
    }
    
    func getInt(forKey key: String) -> Int{
        return remoteConfig.configValue(forKey: key).numberValue.intValue
    }

    func getValue(forKey key: String) -> [String: Any]? {
        let remoteConfigData = remoteConfig.configValue(forKey: key).jsonValue as? [String: Any]
        return remoteConfigData
    }
}
