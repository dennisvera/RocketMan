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
    
    // MARK: - Start Game with Random Word from Reach API
    func startRocketManGame() {
        // Create dictionary URL based off of current options
        let baseURL = "http://app.linkedin-reach.io/words"
        let dif = "?difficulty=" + String(difficulty);
        let min = "&minLength=" + String(wordMinLength);
        let max = "&maxLength=" + String(wordMaxLength + 1);
        let url = URL(string: baseURL + dif + min + max)!;
        
        // Create session and pull random word from dictionary
        urlError = .waiting;
        let session = URLSession.shared;
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            // Break and print if error occurs
            if (error != nil) {
                print("Error retrieving word dictionary.");
                print(error!);
                self.urlError = .noResponse;
                return;
            }
            
            // Split words into an array and access a random word in that array, passing it to start game
            let words = String(data: data!, encoding: .utf8);
            let wordArray = words!.components(separatedBy: CharacterSet.newlines);
            let index = Int(arc4random_uniform(UInt32(wordArray.count)));
            let word = wordArray[index];
            if (word != "") {
                self.urlError = nil;
                self.startGame(word, self.difficulty);
                
                // Set error since no word exists with the set parameters
            }else {
                self.urlError = .noWord;
            }
        })
        task.resume();
    }
    
    //    func startRocketManGame() {
    //        let difficulty = String(self.difficulty)
    //        let wordMinLength = String(self.wordMinLength)
    //        let wordMaxLength = String(self.wordMaxLength + 1)
    //
    //        // Fetch Reach API Client
    //        ReachClient.fetchReachData(difficulty: difficulty, wordMinLength: wordMinLength, wordMaxLength: wordMaxLength) { (gameWord) in
    //            if gameWord != "" {
    //
    //                print("GAMEWORD FROM API CALL: \(gameWord)")
    //
    //                self.urlError = nil
    //                self.startGame(gameWord, self.difficulty)
    //            } else {
    //                self.urlError = .noWord
    //            }
    //        }
    //    }
    
    // MARK: - Creates Current Game With Given Word and Max Number of Guesses
    
    private func startGame(_ word: String, _ difficulty: Int) {
        currentGame = Game(word: word, guessMaximum: guessMaximum, difficulty: difficulty)
    }
    
    /* Submits letter guess to the current game. Returns a Game.GameOutcome option based on the outcome
     * of the guess. If no current game is set, throws an error. */
    func guessLetter(_ guess: Character) throws -> Game.GameOutcome {
        if let outcome = currentGame?.guessLetter(guess) {
            return outcome
        }
        throw GameError.noCurrentGame
    }
    
//    // MARK: - Encoding
//
//    //Archiving Paths
//    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static var ArchiveURL = DocumentsDirectory.appendingPathComponent("RocketMan")
//
//    //NSCoding
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(guessMaximum, forKey: "guessMaximum")
//        aCoder.encode(difficulty, forKey: "difficulty")
//        aCoder.encode(wordMinLength, forKey: "wordMinLength")
//        aCoder.encode(wordMaxLength, forKey: "wordMaxLength")
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        let guessMaximum = aDecoder.decodeInteger(forKey: "guessMaximum")
//        let difficulty = aDecoder.decodeInteger(forKey: "difficulty")
//        let wordMinLength = aDecoder.decodeInteger(forKey: "wordMinLength")
//        let wordMaxLength = aDecoder.decodeInteger(forKey: "wordMaxLength")
//        self.init(guessMaximum: guessMaximum, difficulty: difficulty, wordMinLength: wordMinLength, wordMaxLength: wordMaxLength)
//    }
//
//    //Save &Load functions
//
//    //Saves the current set of table plans
//    static func saveRocketMan(rocketMan: RocketMan) {
//        let successfulSave = NSKeyedArchiver.archiveRootObject(rocketMan, toFile: RocketMan.ArchiveURL.path)
//        if !successfulSave {
//            print("Save error...")
//        }
//    }
//
//    //Loads the saved set of table plans
//    static func loadRocketMan() -> RocketMan? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: RocketMan.ArchiveURL.path) as? RocketMan
//    }
    
}
