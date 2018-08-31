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
        case invalidURL
    }
    
    enum URLError {
        case noWord
        case noResponse
        case waiting
    }
    
    // MARK: - Type Instance
    
    static let sharedInstance = RocketMan()
    
    // MARK: - Properties
    
    var guessMaximum: Int
    var difficulty: Int
    var wordMinLength: Int
    var wordMaxLength: Int
    var currentGame: Game?
    var urlError: URLError? = nil
    
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
    
    // MARK: - Returns True if Game is Over, Otherwise False
    
    func isGameOver() -> Bool {
        if let game = currentGame {
            return game.gameOver
        }
        return false
    }
    
    // MARK: - Returns Number of Guesses Remaining
    
    func remainingGuesses() -> Int {
        return currentGame!.guessMaximum - currentGame!.incorrectGuessNumber
    }
    
    // MARK: - Returns Fraction Number of Guesses Remaining
    
    func remainingGuessesRatio() -> Double {
        return Double(currentGame!.incorrectGuessNumber) / Double(currentGame!.guessMaximum)
    }
    
    // MARK: - Start Game with Random Word from Reach API. Fetch Reach Data
    
    func startRocketManGame() {
        let difficulty = String(self.difficulty)
        let wordMinLength = String(self.wordMinLength)
        let wordMaxLength = String(self.wordMaxLength + 1)
        
        let urlString = "http://app.linkedin-reach.io/words?difficulty=\(difficulty)&minLength=\(wordMinLength)&maxLength=\(wordMaxLength)"
        
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        
        let urlRequest = URLRequest(url: url)
        
        // Create Session
        urlError = .waiting
        let session = URLSession.shared
        
        // Create Data Task
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response Status Code: \(response.statusCode)\n")
            }
            
            if let error = error {
                print("Unable To Fetch Reach Data: \(error)\n")
            } else {
                guard let data = data else { fatalError("Unable to get data: \(String(describing: error?.localizedDescription))") }
                
                // Split words into an array and access a random word in that array, passing it to start game
                let words = String(data: data, encoding: .utf8)
                let wordArray = words!.components(separatedBy: CharacterSet.newlines)
                let index = Int(arc4random_uniform(UInt32(wordArray.count)))
                let word = wordArray[index]
                if (word != "") {
                    self.urlError = nil
                    self.startGame(word, self.difficulty)
                } else {
                    self.urlError = .noWord
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    // MARK: - Creates Current Game With Given Word and Max Number of Guesses
    
    private func startGame(_ word: String, _ difficulty: Int) {
        currentGame = Game(word: word, guessMaximum: guessMaximum, difficulty: difficulty)
    }
    
    // MARK: - Submits Letter Guess To The Current Game. If No Current Game is Set, Throws An Error
    
    func guessLetter(_ guess: Character) throws -> Game.GameOutcome {
        if let game = currentGame?.guessLetter(guess) {
            return game
        }
        throw GameError.noCurrentGame
    }
    
}








