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
    
    @IBOutlet var asteroid1: UIImageView!
    @IBOutlet var asteroid2: UIImageView!
    @IBOutlet var asteroid3: UIImageView!
    @IBOutlet var asteroid4: UIImageView!
    @IBOutlet var asteroid5: UIImageView!
    @IBOutlet var asteroid6: UIImageView!
    
        
    // MARK: - Properties
    
    var rocketMan: RocketMan!
    var asteroids = [UIImageView]()

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
        setupAsteroids()
        
        // Game Word
        print(rocketMan.currentGame!.word)
    }
    
    // MARK: - Helper Methods
    
    private func setupGameWordView() {
        guard let gameWord = rocketMan.currentGame?.word else { return }
        gameWordView.word = gameWord
        gameWordView.setNeedsLayout()
    }
    
    private func setupGameGuessesLabel() {
        guessesLeftLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
    }
    
    private func setupAsteroids() {
        asteroids = [asteroid1, asteroid2, asteroid3, asteroid4, asteroid5, asteroid6]
        hideAllAsteroids()
    }
    
    private func processGame(_ game: Game.GameOutcome) {
        // Update game word
        gameWordView.updateWord(rocketMan.currentGame!.guessArray)
        guessesLeftLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
        updateAsteroidViews(rocketMan.remainingGuessesRatio())
        
        switch game {
        case .lossGuess:
            disableKeyboard()
            gameWordView.fillWord(rocketMan.currentGame!.wordArray)
            guessesLeftLabel.textColor = .red
            guessesLeftLabel.backgroundColor = .white
            guessesLeftLabel.alpha = 1.0
            guessesLeftLabel.text = "You lose!"
        case .winGuess:
            disableKeyboard()
            guessesLeftLabel.textColor = .black
            guessesLeftLabel.backgroundColor = .white
            guessesLeftLabel.alpha = 1.0
            guessesLeftLabel.text = "You win!"
            
        default:
            break
        }
    }
    
    // MARK: Keyboard Helper Methods
    
    private func setupKeyboardButtons() {
        for button in keyboardView.buttons {
            button.backgroundColor = .white
            button.alpha = 0.7
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
            let gameOutcome = try rocketMan.guessLetter(character!)
            processGame(gameOutcome)
        } catch {
           print("No Game is Being Played")
        }
    }
    
    // MARK: - RocketMan Helper Methods
    
    // MARK: - Hide all asteroids
    func hideAllAsteroids() {
        for asteroid in asteroids {
            asteroid.isHidden = true
        }
    }
    
   // MARK: - Show Asteroids
    func updateAsteroidViews(_ ratio: Double) {
        let adjustedRatio = ratio * 6.0
        let lastIndex = Int(adjustedRatio)
        for index in 0..<Int(lastIndex) {
            asteroids[index].alpha = 1
            asteroids[index].isHidden = false
        }
        
        // Show next asteroid
        if (lastIndex < 6) {
            let remainder = adjustedRatio - Double(lastIndex)
            asteroids[lastIndex].isHidden = false
            asteroids[lastIndex].alpha = CGFloat(remainder)
        }
    }
    
}


