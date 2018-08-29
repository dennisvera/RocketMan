//
//  GameViewController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/28/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet var guessesLeftLabel: UILabel!
    @IBOutlet var keyboardView: KeyboardView!
    @IBOutlet var gameWordView: GameWordView!
    
    // MARK: - Properties
    
    var rocketMan: RocketMan!

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        setupGameWordView()
        setupKeyboardButtons()
        setupGameGuessesLabel()
        
        // Game Word Print
        print(rocketMan.currentGame!.word)
    }
    
    // MARK: - Helper Methods
    
    private func setupGameWordView() {
        guard let gameWord = rocketMan.currentGame?.word else { return }
        gameWordView.word = gameWord
        gameWordView.backgroundColor = .white
        gameWordView.setNeedsLayout()
    }
    
    private func setupGameGuessesLabel() {
        guessesLeftLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
    }
    
    private func processGame(_ game: Game.GameOutcome) {
        // Update game word
        gameWordView.updateWord(rocketMan.currentGame!.guessArray)
        guessesLeftLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
        
        switch game {
        case .lossGuess:
            disableKeyboard()
            gameWordView.fillWord(rocketMan.currentGame!.wordArray)
            guessesLeftLabel.text = "You lose!"
        case .winGuess:
            disableKeyboard()
            guessesLeftLabel.text = "You win!"
            
        default:
            break
        }
    }
    
    // MARK: Keyboard Helper Methods
    
    private func setupKeyboardButtons() {
        for button in keyboardView.buttons {
            button.addTarget(self, action: #selector(keyboardTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Keyboard Disables, if You Win Or Lose
    private func disableKeyboard() {
        for button in keyboardView.buttons {
            button.isEnabled = false
        }
    }
    
    // MARK: - Keyboard Button Tapped, Letter Passed to Game
    @objc private func keyboardTapped(_ sender: KeyboardButton) {
        let character = sender.key
        sender.isEnabled = false
        sender.alpha = 0.3
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        
        do {
            let outcome = try rocketMan.guessLetter(character!)
            processGame(outcome)
        } catch {
           print("No Game is Being Played")
        }
    }
    
}


