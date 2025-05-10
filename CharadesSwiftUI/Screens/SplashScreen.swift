//
//  ContentView.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import SwiftUI

struct SplashScreen: View {
    
    @StateObject private var viewModel = SplashScreenViewModel()
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage.splashImg)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .tint(.white)
                    .scaleEffect(2)
                    .padding(.bottom, 8)
            }
        }
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        ScreenDetails.bottomSafeArea = geometry.safeAreaInsets.bottom
                    }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
