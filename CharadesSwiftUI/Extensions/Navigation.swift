//
//  Navigation.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import SwiftUI

func setRootView<Content: View>(_ view: Content) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let keyWindow = windowScene.windows.first else {
        return
    }
    
    UIView.transition(with: keyWindow, duration: 0.33, options: .transitionCrossDissolve, animations: {
        keyWindow.rootViewController = UIHostingController(rootView: view)
        keyWindow.makeKeyAndVisible()
    })
}
