//
//  DeckView.swift
//  CharadesSwiftUI
//
//  Created by Admin on 07/05/25.
//

import SwiftUI

struct DeckView: View {
    let decks: [Deck] = FirebaseRemoteConfigManager.shared.allDecks!

    // Define 2 fixed-width columns
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(decks, id: \.self) { deck in
                    GeometryReader { geometry in
                        let size = geometry.size.width
                        ZStack {
                            
                            if let imgUrl = URL(string: deck.bgIcon ?? "") {
                                RemoteImageView(imageUrl: imgUrl)
                            }
                            
                            VStack {
                                HStack {
                                    let selectionImg: UIImage = deck.isSelected ?? false ? UIImage.deckSelected : UIImage.deckUnSelected
                                    Image(uiImage: selectionImg)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .padding([.top, .leading], 16)
                                    
                                    Spacer()
                                    
                                    if deck.isPremium ?? true && UserManager.shared.currentUserType == .free {
                                        Image(uiImage: UIImage.premiumDeck)
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                    }
                                }
                                
                                Spacer()
                                
                                Text(deck.name ?? "Unnamed Deck")
                                    .foregroundStyle(Color.white)
                                    .font(.custom(FontStyle.semiBold, size: 24))
                                    .padding([.bottom, .leading, .trailing], 8)
                            }
                        }
                        .frame(width: size, height: size)
                        .background(Color(hex: deck.bgColor ?? "#E0E0E0"))
                        .cornerRadius(12)
                        .shadow(radius: 3)
                    }.aspectRatio(1, contentMode: .fit)
                }
            }
            .padding()
        }
    }
}

#Preview {
    DeckView()
}
