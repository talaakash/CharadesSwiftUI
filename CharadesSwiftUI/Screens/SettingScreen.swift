//
//  SettingScreen.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import SwiftUI

private enum Settings: CaseIterable {
    case control, howToPlay, rateUs, contactUs, shareApp
    
    var name: String {
        switch self {
        case .control:
            return "gyroControl".localize()
        case .howToPlay:
            return "howToPlaySetting".localize()
        case .rateUs:
            return "rateUsSetting".localize()
        case .contactUs:
            return "contactUsSetting".localize()
        case .shareApp:
            return "shareAppSetting".localize()
        }
    }
    
    var iconName: UIImage {
        switch self {
        case .control:
            return UIImage.howToPlay
        case .howToPlay:
            return UIImage.howToPlay
        case .rateUs:
            return UIImage.rate
        case .contactUs:
            return UIImage.contactUs
        case .shareApp:
            return UIImage.share
        }
    }
}

struct SettingScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let settingOptions = Settings.allCases
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage.bgImg)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(uiImage: UIImage.back)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 16)
                        }
                        
                        Text("settingHeading".localize())
                            .foregroundStyle(Color.white)
                            .font(.custom(FontStyle.bold, size: 24))
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    
                    // Body
                    List(settingOptions, id: \.self) { option in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                            HStack {
                                Image(uiImage: option.iconName)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.all, 8)
                                
                                Text(option.name)
                                    .foregroundStyle(Color.white)
                                    .font(.custom(FontStyle.medium, size: 20))
                                
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                    .padding(.all, 16)
                    .listItemTint(Color.black)
                    .listRowSpacing(16)
                    .listStyle(.plain)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingScreen()
}
