//
//  CharadesSwiftUIApp.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import SwiftUI
import FirebaseCore

@main
struct CharadesSwiftUIApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
