//
//  UserManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation

enum UserType {
    case free, paid
}

class UserManager {
    static let shared = UserManager()
    var currentUserType: UserType = .free {
        didSet {
            switch currentUserType {
            case .free:
                UserDefaults.standard.setValue(false, forKey: "isPremiumUnlocked")
            case .paid:
                UserDefaults.standard.setValue(true, forKey: "isPremiumUnlocked")
            }
        }
    }
    
    private init(){ }
    
    func getUserType() -> UserType {
        return currentUserType
    }
    
    func setUserType(type: UserType){
        self.currentUserType = type
    }
    
    func setTransactionId(id: String){
        UserDefaults.standard.setValue(id, forKey: "transactionId")
    }
    
    func getTransactionId() -> String {
        if let transactionId = UserDefaults.standard.value(forKey: "transactionId") as? String{
            return transactionId
        }
        return ""
    }
    
    func getPlanId() -> String? {
        if let planId = UserDefaults.standard.value(forKey: "purchasedPlanId") as? String {
            return planId
        }
        return nil
    }
    
    func getApiVersionKey() -> String{
        return "\("jsonUpdateDate")_\(UtilityManager.shared.getLocaleCountryCode() ?? "en")"
    }
    
    func setPlanId(productId: String){
        UserDefaults.standard.setValue(productId, forKey: "purchasedPlanId")
        UserDefaults.standard.synchronize()
    }
    
    func removeUserDetails(){
        UserDefaults.standard.removeObject(forKey: "purchasedPlanId")
        UserDefaults.standard.removeObject(forKey: "transactionId")
    }
    
    func isOfferAppeard() -> Bool{
        return UserDefaults.standard.bool(forKey: "isNewOfferAppeared")
    }
    
    func isOfferExpired() -> Bool{
        let savedTime = UserDefaults.standard.integer(forKey: "appSpentTimeForOffer")
        
        let startInterval = AppConstants.offerDuration
        let endInterval = TimeInterval(savedTime)
        let difference = startInterval - endInterval
        return difference <= 0
    }
    
    func calculateTimeIntervalDifference(spentDuration: TimeInterval) -> String {
        let difference = spentDuration
        
//        let hours = Int(difference) / 3600
        let minutes = (Int(difference) % 3600) / 60
        let seconds = Int(difference) % 60
        
        // Format as hh:mm:ss
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func calculateOriginalPrice(orignalPrice: Decimal, discountRate: Double) -> Int {
        let originalPrice = orignalPrice / Decimal(1 - discountRate)
        // Always round up to the nearest whole number
        return Int(ceil(NSDecimalNumber(decimal: originalPrice).doubleValue))
    }
}
