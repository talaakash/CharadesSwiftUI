//
//  Score.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//


import Foundation

class Score {
    var teamName: String
    var totalScore: Int
    var words: [String]
    var answerType: [Bool] {
        didSet {
            self.totalScore = answerType.filter({ $0 == true}).count
        }
    }
    
    init(teamName: String) {
        self.teamName = teamName
        self.totalScore = 0
        self.words = []
        self.answerType = []
    }
}
