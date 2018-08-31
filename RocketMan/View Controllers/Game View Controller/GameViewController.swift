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

    @IBOutlet var gameBoardLabel: UILabel!
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
        gameWordView.alpha = 0.6
        gameWordView.layer.masksToBounds = true
        gameWordView.layer.cornerRadius = 5
        gameWordView.setNeedsLayout()
    }
    
    private func setupGameGuessesLabel() {
        gameBoardLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        gameBoardLabel.layer.masksToBounds = true
        gameBoardLabel.layer.cornerRadius = 5
        gameBoardLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
    }
    
    private func setupAsteroids() {
        asteroids = [asteroid1, asteroid2, asteroid3, asteroid4, asteroid5, asteroid6]
        hideAllAsteroids()
    }
    
    private func processGame(_ game: Game.GameOutcome) {
        // Update game word
        gameWordView.updateWord(rocketMan.currentGame!.guessArray)
        gameBoardLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
        updateAsteroidViews(rocketMan.remainingGuessesRatio())
        
        switch game {
        case .lossGuess:
            disableKeyboard()
            gameWordView.fillWord(rocketMan.currentGame!.wordArray)
            gameBoardLabel.textColor = .red
            gameBoardLabel.backgroundColor = .white
            gameBoardLabel.layer.masksToBounds = true
            gameBoardLabel.layer.cornerRadius = 5
            gameBoardLabel.alpha = 1.0
            gameBoardLabel.text = "Try Again!"
        case .winGuess:
            disableKeyboard()
            gameBoardLabel.textColor = .red
            gameBoardLabel.backgroundColor = .white
            gameBoardLabel.layer.masksToBounds = true
            gameBoardLabel.layer.cornerRadius = 5
            gameBoardLabel.alpha = 1.0
            gameBoardLabel.text = "RocketMan!"
            
        default:
            break
        }
    }
    
    // MARK: Keyboard Helper Methods
    
    private func setupKeyboardButtons() {
        for button in keyboardView.buttons {
            button.alpha = 0.6
            button.backgroundColor = .white
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(keyboardTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Keyboard Disables, if You Win Or Lose
    private func disableKeyboard() {
        for button in keyboardView.buttons {
            button.isEnabled = false
        }
    }
    
    // MARK: - Sets Keyboard Button Color When Tapped
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


