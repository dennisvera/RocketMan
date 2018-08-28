//
//  RocketMan.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class RocketMan: NSObject {
    
    // MARK: - Type Instance
    
    static let sharedInstance = RocketMan()
    
    var guessMaximum: Int
    var difficulty: Int
    var wordMinLength: Int
    var wordMaxLength: Int
    var currentGame: Game?
    
    // MARK: - Initializers
    
    override init() {
        self.guessMaximum = 6
        self.difficulty = 1
        self.wordMinLength = 2
        self.wordMaxLength = 12
        self.currentGame = nil
    }
    
    init(guessMaximum: Int, difficulty: Int, wordMinLength: Int, wordMaxLength: Int ) {
        self.guessMaximum = guessMaximum
        self.difficulty = difficulty
        self.wordMinLength = wordMinLength
        self.wordMaxLength = wordMaxLength
        self.currentGame = nil
    }
    
    // MARK: - Requesting & Parsing Data
    
    func fetchRocketManWord() {
        let difficulty = String(self.difficulty)
        let wordMinLength = String(self.wordMinLength)
        let wordMaxLength = String(self.wordMaxLength + 1)
        
        // Fetch Reach API Client
        ReachClient.fetchReachData(difficulty: difficulty, wordMinLength: wordMinLength, wordMaxLength: wordMaxLength) { (word) in
//            print(self.guessMaximum)
//            print(self.difficulty)
//            print(self.wordMinLength)
//            print(self.wordMaxLength)

            if word != "" {
                print(word)
                self.startGame(word, self.difficulty)
            }
        }
    }
    
    
    // MARK: - Helper Method Creates Current Game With Given Word and Max Number of Guesses
    
    private func startGame(_ word: String, _ difficulty: Int) {
        currentGame = Game(word: word, guessMax: guessMaximum, difficulty: difficulty)
    }
    
}






