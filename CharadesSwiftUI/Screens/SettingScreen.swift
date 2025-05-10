//
//  SettingScreen.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import SwiftUI

struct SettingScreen: View {
    
    @StateObject private var viewModel = SettingScreenVM()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: HowToPlayScreen(), isActive: $viewModel.howToPlay) {
                    EmptyView()
                }
                
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
                    List(viewModel.settingOptions, id: \.self) { option in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                            HStack {
                                Image(uiImage: option.icon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.all, 8)
                                
                                Text(option.name) 
                                    .foregroundStyle(Color.white)
                                    .font(.custom(FontStyle.medium, size: 20))
                                 
                                Spacer()
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.viewModel.selected(option: option)
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
            NavigationLink(destination: HowToPlayScreen(), isActive: $viewModel.howToPlay) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingScreen()
}
