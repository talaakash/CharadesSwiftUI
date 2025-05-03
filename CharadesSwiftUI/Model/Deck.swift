//
//  Deck.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//


import Foundation

class Deck: Codable {
    var id: Int?
    var name: String?
    var bgColor: String?
    var isPremium: Bool?
    var words: [String]?
    var bgIcon:String?
    var isSelected: Bool? = false
}

class DecksData {
    let deckType: JsonTypes
    var decks: [Deck]
    
    init(deckType: JsonTypes, decks: [Deck]) {
        self.deckType = deckType
        self.decks = decks
    }
}
