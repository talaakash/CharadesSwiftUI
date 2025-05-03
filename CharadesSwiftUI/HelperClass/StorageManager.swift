//
//  StorageManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation

enum JsonTypes: String {
    case allDecks = "AllDecks"
    case usersDeck = "UsersDeck"
    case localDeck = "LocalDeck"
}

class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    func storeJson(typeOfJson: JsonTypes, json: [[String: Any]]) -> Bool {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        do {
            let fileName = (typeOfJson == .usersDeck ? "\(typeOfJson.rawValue)".appending(".json") : "\(typeOfJson.rawValue)_\(UtilityManager.shared.getLocaleCountryCode() ?? "en")".appending(".json"))
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let fileURL = documentDirectory?.appendingPathComponent(fileName)
            try jsonData.write(to: fileURL ?? URL(fileURLWithPath: ""))
            return true
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func getJson<T: Decodable>(inType: T.Type,typeOfJson: JsonTypes) -> T? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = (typeOfJson == .usersDeck ? "\(typeOfJson.rawValue)".appending(".json") : "\(typeOfJson.rawValue)_\(UtilityManager.shared.getLocaleCountryCode() ?? "en")".appending(".json"))

        let fileURL = documentDirectory.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedObject
        } catch {
            debugPrint("Error reading JSON from file: \(error)")
            return nil
        }
    }
}
