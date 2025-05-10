//
//  HowToPlayScreen.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 04/05/25.
//

import SwiftUI

struct Instructions: Hashable {
    var icon: UIImage
    var title: String
    var message: String
}

struct HowToPlayScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State var instructions: [Instructions] = [
        Instructions(icon: UIImage.choose, title: "chooseDeckInsTitle".localize(), message: "chooseDeckInsDescription".localize()),
        Instructions(icon: UIImage.gameMode, title: "modeInsTitle".localize(), message: "modeInsDescription".localize()),
        Instructions(icon: UIImage.search, title: "startInsTitle".localize(), message: "startInsDescription".localize()),
        Instructions(icon: UIImage.act, title: "guessInsTitle".localize(), message: "guessInsDescription".localize()),
        Instructions(icon: UIImage.rotate2, title: "correctGuessInsTitle".localize(), message: "correctGuessInsDescription".localize()),
        Instructions(icon: UIImage.rotate1, title: "wrongGuessInsTitle".localize(), message: "wrongGuessInsDescription".localize()),
        Instructions(icon: UIImage.timer, title: "timerEndInsTitle".localize(), message: "timerEndInsDescription".localize())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(uiImage: UIImage.bgImg)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    // Heading
                    HStack {
                        Text("howToPlaySetting".localize())
                            .foregroundStyle(Color.white)
                            .font(.custom(FontStyle.bold, size: 36))
                            .padding(.leading, 16)
                        
                        Spacer()
                    }
                    
                    ZStack {
                        
                        List($instructions, id: \.self) { instruction in
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                HStack {
                                    Image(uiImage: instruction.icon.wrappedValue)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(instruction.title.wrappedValue)
                                            .foregroundStyle(Color.white)
                                            .font(.custom(FontStyle.medium, size: 20))
                                            .padding(.top, 8)
                                        
                                        Spacer()
                                        
                                        Text(instruction.message.wrappedValue)
                                            .foregroundStyle(Color.white)
                                            .font(.custom(FontStyle.light, size: 20))
                                            .padding(.bottom, 8)
                                    }
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                        }
                        .padding([.leading, .trailing, .top], 16)
                        .listItemTint(Color.black)
                        .listRowSpacing(16)
                        .listStyle(.plain)
                        .ignoresSafeArea(.container, edges: .bottom)
                        
                        VStack {
                            Spacer()
                            // Bottom
                            Button {
                                dismiss()
                            } label: {
                                ZStack {
                                    Image(uiImage: UIImage.btnBG)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("gotItBtnTitle".localize())
                                        .foregroundStyle(Color.black)
                                        .font(.custom(FontStyle.bold, size: 24))
                                }
                            }.padding(.all, 16)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HowToPlayScreen()
}
