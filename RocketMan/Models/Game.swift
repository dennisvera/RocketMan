//
//  Game.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/27/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class Game {
    
    // MARK: - Enums
    
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
        
        // Set Up Arrays For Selected Word
        for letter in uppercasedWord {
            wordArray.append(letter)
            guessArray.append("_")
        }
    }
    
    // MARK: - Returns True if Player Wins. Otherwise False
    
    func winGame() -> Bool {
        if revealedLetters == wordArray.count {
            return true
        }
        return false
    }
    
    // MARK: - Returns True if Player Lost. Otherwise False

    func lossGame() -> Bool {
        if incorrectGuessNumber == guessMaximum {
            return true
        }
        return false
    }
    
    // MARK: - Given a Character, Will Update Guess Letter to Guess Array
    
    func guessLetter(_ guess: Character) -> GameOutcome {
        // Game is over
        if gameOver { return .gameOver }
        
        // Already guessed
        if guessedLetters.contains(guess) { return .alreadyGuessed }
        
        // Update guess, run through word with guess, and check if incorrect
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
    
    // MARK: - Selects Word With Guess And Updates the Guess Array. If the Guess is the Game Word, Return True
    
    private func guessCheck(_ guess: Character) -> Bool {
        var correctGuess = false
        for (index, letter) in wordArray.enumerated() {
            if letter == guess {
                correctGuess = true
                guessArray[index] = letter
                revealedLetters += 1
            }
        }
        return correctGuess
    }
    
}


