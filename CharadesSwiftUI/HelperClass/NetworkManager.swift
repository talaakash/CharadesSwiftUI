//
//  NetworkManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//


import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private lazy var networkMonitor = try! Reachability()
    var isNetworkAvailable = false
    
    private init(){ }
        
    func startMonitor(isNetworkAvailable: @escaping (Bool) -> Void){
        var isUpdateGiven: Bool = false
        networkMonitor.whenReachable = { _ in
            debugPrint("Internet is available")
            self.isNetworkAvailable = true
            if !isUpdateGiven {
                isUpdateGiven = true
                isNetworkAvailable(true)
            }
        }
        networkMonitor.whenUnreachable = { _ in
            debugPrint("Internet is not available")
            self.isNetworkAvailable = false
            if !isUpdateGiven {
                isUpdateGiven = true
                isNetworkAvailable(false)
            }
        }
        
        do {
            try networkMonitor.startNotifier()
        } catch let error{
            debugPrint("Error: \(error.localizedDescription)")
            self.isNetworkAvailable = false
            isNetworkAvailable(false)
        }
    }
}
