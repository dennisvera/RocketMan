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
    @IBOutlet var backButton: UIButton!
    @IBOutlet var resetGameButton: UIButton!
    @IBOutlet var guessesLeftLabel: UILabel!
    @IBOutlet var keyboardView: KeyboardView!
    @IBOutlet var gameWordView: GameWordView!
    
    // MARK: - Properties
    
    var rocketMan: RocketMan!
    var okButton: UIAlertAction! // Stored for future enabling/disabling

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DEBUG
        print(rocketMan.currentGame!.word)
        
        // Set up secret word view
        guard let gameWord = rocketMan.currentGame?.word else { return }
        gameWordView.word = gameWord
        gameWordView.backgroundColor = .white
        gameWordView.setNeedsLayout()
        
        // Set up target keyboard buttons
        for button in keyboardView.buttons {
            button.addTarget(self, action: #selector(keyboardTapped(_:)), for: .touchUpInside)
        }
        keyboardView.wordButton.addTarget(self, action: #selector(wordButtonTapped(_:)), for: .touchUpInside)
        
        // Set up  guesses left label and hide body parts
        guessesLeftLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
    }
    
    // MARK: - Game Functions
    
    /* Function that processes the given game outcome. Updates appropriate views based on the outcome.
     * Disables keyboard and presents the appropriate message if the game is over. */
    func processOutcome(_ outcome: Game.GameOutcome) {
        // Update secret word, guess notification, and gallows
        gameWordView.updateWord(rocketMan.currentGame!.guessArray)
        guessesLeftLabel.text = "Guesses Left: " + String(rocketMan.remainingGuesses())
        
        switch outcome {
        case .lossGuess:
            disableKeyboard()
            gameWordView.fillWord(rocketMan.currentGame!.wordArray)
            guessesLeftLabel.text = "You lose!"
//            Hangman.saveHangman(hangman: hangman);
        case .winGuess:
            disableKeyboard()
            guessesLeftLabel.text = "You win!"
//            Hangman.saveHangman(hangman: hangman);
            
        default:
            break
        }
    }
    
    // MARK Keyboard Helper Methods
    
    /* Function that disables all keyboard buttons from touch input. */
    private func disableKeyboard() {
        for button in keyboardView.buttons {
            button.isEnabled = false
        }
        keyboardView.wordButton.isEnabled = false
    }
    
    /* Function handling a keyboard button tap. If tapped, passes a letter guess to the Hangman game. */
    @objc func keyboardTapped(_ sender: KeyboardButton) {
        let character = sender.key
        sender.isEnabled = false
        sender.alpha = 0.3;
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        
        do {
            let outcome = try rocketMan.guessLetter(character!)
            processOutcome(outcome);
        } catch {
            // No current game
        }
    }
    
    /* Function handling a guess word button tap. Presents an alert asking for a word to be guessed. */
    @objc func wordButtonTapped(_ sender: KeyboardButton) {
        let alertController = UIAlertController(title: "Write in your guess:", message: "Word must be between the length of 2 and 12, and contain only letters.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.checkWord(_:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Guess", style: .default) { (_) in
            
            do {
                let word = alertController.textFields![0].text!
//                let outcome = try self.rocketMan.guessWord(word)
//                self.processOutcome(outcome)
            } catch {
                // No current game
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        okAction.isEnabled = false
        self.okButton = okAction
        self.present(alertController, animated: true, completion: nil)
    }
    
    /* Helper function that checks to see if the word given is valid for a game of hangman. */
    @objc func checkWord(_ sender: UITextField) {
        let allowedCharacters = CharacterSet(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM")
        let word = sender.text!
        if (word.characters.count >= 2 && word.characters.count <= 12 && word.rangeOfCharacter(from: allowedCharacters.inverted) == nil) {
            okButton.isEnabled = true
        } else {
            okButton.isEnabled = false
        }
    }
    
    
}










