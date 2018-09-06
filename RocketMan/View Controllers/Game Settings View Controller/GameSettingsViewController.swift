//
//  GameSettingsViewController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

final class GameSettingsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playButton: UIButton!
    
    // MARK: - Type Instance
    
    let rocketMan = RocketMan.sharedInstance
    
    // MARK: - Properties

    var difficultyLabel: UILabel!
    var difficultyStepper: UIStepper!
    var wordMinimumLengthLabel: UILabel!
    var wordMinimumLengthStepper: UIStepper!
    var wordMaximumLengthLabel: UILabel!
    var wordMaximumLengthStepper: UIStepper!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("\n rocketMan.wordMinLength: \(rocketMan.wordMinimumLength) \n")
        print("\n rocketMan.wordMaxLength: \(rocketMan.wordMaximumLength) \n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = 10
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GameViewController.reuseIdentifier {
            let destination = segue.destination as! GameViewController
            destination.rocketMan = rocketMan
        }        
    }
        
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: Any) {
        // Start Game
        rocketMan.startRocketManGame()
        
        // Wait for response from URL session
        while rocketMan.urlError == .waiting { }
        // Check if there is an error in obtaining a word with the given parameters
        if rocketMan.urlError == .noWord {
            showAlert(with: "No Word Found", and: "The current settings could not produce a word. Change difficulty and/or word length and try again.")
            return
            
            // Check if there is an error in reaching the server
        } else if rocketMan.urlError == .noResponse {
            showAlert(with: "Unable to Fetch Word Game Data", and: "Please make sure your device is connected over Wi-Fi or cellular.")
            return
        }
        
        performSegue(withIdentifier: GameViewController.reuseIdentifier, sender: self)
    }
}

// MARK: - UITableView Data Source Extension

extension GameSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as? SettingsTableViewCell else { fatalError("Unexpected Index Path") }
        
        // Configure Cell
        configure(cell, at: indexPath)
        
        return cell
    }
    
    // MARK: - TableView Cell Helper Method
    
    private func configure(_ cell: SettingsTableViewCell, at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.settingsTitleLabel.text = "Difficulty"
            cell.settingsNumberLabel.text = String(rocketMan.difficulty)
            difficultyLabel = cell.settingsNumberLabel
            difficultyStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordDifficulty(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 10
            cell.settingsStepper.minimumValue = 1
            cell.settingsStepper.value = Double(rocketMan.difficulty)
        case 1:
            cell.settingsTitleLabel.text = "Minimum Word Length"
            cell.settingsNumberLabel.text = String(rocketMan.wordMinimumLength)
            wordMinimumLengthLabel = cell.settingsNumberLabel
            wordMinimumLengthStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordMinimumLength(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
            cell.settingsStepper.value = Double(rocketMan.wordMinimumLength)
        case 2:
            cell.settingsTitleLabel.text = "Maximum Word Length"
            cell.settingsNumberLabel.text = String(rocketMan.wordMaximumLength)
            wordMaximumLengthLabel = cell.settingsNumberLabel
            wordMaximumLengthStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordMaximumLength(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
            cell.settingsStepper.value = Double(rocketMan.wordMaximumLength)
            
        default:
            break
        }
    }
    
    // MARK: - Stepper Helper Methods
    
    // MARK: - Difficulty Stepper Updates Difficulty Value
    @objc private func wordDifficulty(_ sender: UIStepper) {
        let newDifficultyValue = Int(sender.value)
        difficultyLabel.text = String(newDifficultyValue)
        rocketMan.difficulty = newDifficultyValue
    }
    
    // MARK: - Word Minimum Stepper Updates Word Minimum Legth Value
    @objc private func wordMinimumLength(_ sender: UIStepper) {
        let newWordMinimumLenghtValue = Int(sender.value)
        wordMinimumLengthLabel.text = String(newWordMinimumLenghtValue)
        rocketMan.wordMinimumLength = newWordMinimumLenghtValue
        
        // Updates maximum word length if minimum word length exceeds it
        if newWordMinimumLenghtValue > rocketMan.wordMaximumLength {
            wordMaximumLengthLabel.text = String(newWordMinimumLenghtValue)
            wordMaximumLengthStepper.value = Double(newWordMinimumLenghtValue)
            rocketMan.wordMaximumLength = newWordMinimumLenghtValue
        }
    }
    
    // MARK: - Word Maximum Stepper Updates Word Maximum Legth Value
    @objc private func wordMaximumLength(_ sender: UIStepper) {
        let newWordMaximumLenghtValue = Int(sender.value)
        wordMaximumLengthLabel.text = String(newWordMaximumLenghtValue)
        rocketMan.wordMaximumLength = newWordMaximumLenghtValue
        
        // Updates minimum word length if maximum word length exceeds it
        if newWordMaximumLenghtValue < rocketMan.wordMinimumLength {
            wordMinimumLengthLabel.text = String(newWordMaximumLenghtValue)
            wordMinimumLengthStepper.value = Double(newWordMaximumLenghtValue)
            rocketMan.wordMinimumLength = newWordMaximumLenghtValue
        }
    }
    
}

