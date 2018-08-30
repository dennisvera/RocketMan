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
    var rocket = [UIImageView]()

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
        
        // Game Word
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
        hideAllParts()
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
    
    // MARK: - RocketMan Helper Methods
    
    /* Function that hides all parts of RocketMan. */
    func hideAllParts() {
        for part in rocket {
            part.isHidden = true
        }
    }
    
    /* Function that reveals parts of the hangman based off of the given ratio. */
    func updateRocket(_ ratio: Double) {
        let adjustedRatio = ratio * 6.0
        let lastIndex = Int(adjustedRatio)
        for index in 0..<Int(lastIndex) {
            rocket[index].alpha = 1
            rocket[index].isHidden = false
        }
        
        // Show portion of next part if remainder
        if (lastIndex < 6) {
            let remainder = adjustedRatio - Double(lastIndex)
            rocket[lastIndex].isHidden = false
            rocket[lastIndex].alpha = CGFloat(remainder)
        }
        
        // Show frown if all parts shown
        if (ratio == 1) {
        }
    }
    
}


