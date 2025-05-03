//
//  HomeScreen.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage.bgImg)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("appName".localize())
                            .foregroundStyle(Color.white)
                            .font(.custom(FontStyle.bold, size: 32))
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingScreen(), label: {
                            Image(uiImage: UIImage.setting)
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 16)
                        })
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
