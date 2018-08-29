//
//  RocketMan.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class RocketMan: NSObject {
    
    // MARK: - Enums
    
    enum GameError : Error {
        case noCurrentGame
        case invalidDictionaryURL
    }
    
    enum URLError {
        case noWord
        case noResponse
        case waiting
    }

    // MARK: - Type Instance
    
    static let sharedInstance = RocketMan()
    
    // MARK: - Type Instance
    
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
        ReachClient.fetchReachData(difficulty: difficulty, wordMinLength: wordMinLength, wordMaxLength: wordMaxLength) { (selectedGameWord) in
            if selectedGameWord != "" {
                print(selectedGameWord)
                self.startGame(selectedGameWord, self.difficulty)
            }
        }
    }
    
    // MARK: - Returns True if Game is Over, Otherwise False
    
    func isGameOver() -> Bool {
        if let game = currentGame {
            return game.gameOver
        }
        
        return false
    }
    
    // MARK: - Returns True if Current Game is On, Otherwise False
    
    func hasGame() -> Bool {
        return currentGame != nil
    }
    
    // MARK: - Clear Current Game
    
    func clearGame() {
        currentGame = nil
    }
    
    // MARK: - Returns Number of Guesses Remaining
    
    func remainingGuesses() -> Int {
        return currentGame!.guessMaximum - currentGame!.incorrectGuessNumber
    }
    
    // MARK: - Returns Fraction Number of Guesses Remaining
    
    func remainingGuessesRatio() -> Double {
        return Double(currentGame!.incorrectGuessNumber) / Double(currentGame!.guessMaximum)
    }
    
    // MARK: - Creates Current Game With Given Word and Max Number of Guesses
    
    private func startGame(_ word: String, _ difficulty: Int) {
        currentGame = Game(word: word, guessMaximum: guessMaximum, difficulty: difficulty)
    }
        
}






