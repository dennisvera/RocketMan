//
//  Game.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/27/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class Game {
    
    // MARK: - Enumerations
    
    enum GameOutcome {
        case gameOver
        case alreadyGuessed
        case incorrectGuess
        case correctGuess
        case winGuess
        case lossGuess
    }
    
    // MARK: - Properties
    
    var word: String
    var wordArray = [Character]()
    var guessArray = [Character]()
    var guessMaximum: Int
    var incorrectGuessNumber: Int = 0
    var guessNumber: Int = 0
    var revealedLetters: Int = 0
    var guessedLetters = Set<Character>()
    var difficulty: Int
    var gameOver: Bool = false
    
    // MARK: - Initializers
    
    init(word: String, guessMaximum: Int, difficulty: Int) {
        let uppercasedWord = word.uppercased()
        self.word = uppercasedWord
        self.guessMaximum = guessMaximum
        self.difficulty = difficulty
        
        //Set up arrays for the given word
        for letter in uppercasedWord.characters {
            wordArray.append(letter)
            guessArray.append("_")
        }
    }
    
    // MARK: - Returns true if the Game Ended as a Loss. Otherwise, Returns False
    
    func winGame() -> Bool {
        if (revealedLetters == wordArray.count) {
            return true
        }
        return false
    }
    
    // MARK: - Returns true if the game has neded as a loss??? Otherwise, returns false
    
    func lossGame() -> Bool {
        if (incorrectGuessNumber == guessMaximum) {
            return true
        }
        return false
    }
    
    // MARK: - Given a Character, will update guess current status of the guess array
    
    func guessLetter(_ guess: Character) -> GameOutcome {
        // Game already over
        if gameOver { return .gameOver }
        
        // Already guessed
        if guessedLetters.contains(guess) { return .alreadyGuessed }
        
        // Update guess stats, run through word with guess, and check if incorrect
        guessNumber += 1
        guessedLetters.insert(guess)
        if !guessCheck(guess) {
            incorrectGuessNumber += 1
            
            if lossGame() {
                gameOver = true
                return .lossGuess
            }
            return .incorrectGuess
        }
        
        // Win check
        if winGame() {
            gameOver = true
            return .winGuess
        }
        
        // Otherwise, correct guess
        return .correctGuess
    }
    
    // MARK: - Selects Word With Guess And Updates The Guess Array. If The Guess is The Game Word, Return True
    
    private func guessCheck(_ guess: Character) -> Bool {
        var correctGuess = false;
        for (index, letter) in wordArray.enumerated() {
            if (letter == guess) {
                correctGuess = true
                guessArray[index] = letter
                revealedLetters += 1
            }
        }
        return correctGuess
    }
    
    // MARK: - Guess the Game Word. Given a String, checks to see if it matches the game word
    
    func guessWord(_ guess: String) -> GameOutcome {
        // Game already over
        if gameOver { return .gameOver }
        
        // Uppercase entire guess
        let guess = guess.uppercased()
        
        // Check if guess is correct
        guessNumber += 1
        if (guess == word) {
            revealAll()
            gameOver = true
            return .winGuess
        }
        
        // Check if a losing guess, otherwise incorrect guess
        incorrectGuessNumber += 1
        if lossGame() {
            gameOver = true
            return .lossGuess
        }
        return .incorrectGuess
    }
    
    // MARK: - Presents All Words In The Guess Array
    
    private func revealAll() {
        guessArray = wordArray
    }
    
    // MARK: - Returns a String From GuessArray. Underscores Represent Letters Of The Word That Have Not Yet Been Guessed
    
    func getCurrentGuess() -> String {
        var string = ""
        for character in guessArray {
            string += String(character)
        }
        return string
    }
    
}


