//
//  GameSettingsViewController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

final class GameSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Type Instance
    
    let rocketMan = RocketMan.sharedInstance
    
    // MARK: - Properties
    
    var difficultyLabel: UILabel!
    var difficultyStepper: UIStepper!
    var wordMinLengthLabel: UILabel!
    var wordMinLengthStepper: UIStepper!
    var wordMaxLengthLabel: UILabel!
    var wordMaxLengthStepper: UIStepper!
    var guessMaximumLabel: UILabel!
    var guessMaximumStepper: UIStepper!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
    }
    
    // MARK: - Helper Method
    
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: Any) {
        rocketMan.fetchRocketManWord()
    }
    
}

// MARK: - UITableView Data Source

extension GameSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            cell.settingsTitleLabel.text = "Guess Limit"
            cell.settingsNumberLabel.text = String(rocketMan.guessMaximum)
            guessMaximumLabel = cell.settingsNumberLabel
            guessMaximumStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(guessMaximum(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 10
            cell.settingsStepper.minimumValue = 1
            cell.settingsStepper.value = Double(rocketMan.guessMaximum)
        case 1:
            cell.settingsTitleLabel.text = "Difficulty"
            cell.settingsNumberLabel.text = String(rocketMan.difficulty)
            difficultyLabel = cell.settingsNumberLabel
            difficultyStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordDifficulty(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 10
            cell.settingsStepper.minimumValue = 1
            cell.settingsStepper.value = Double(rocketMan.difficulty)
        case 2:
            cell.settingsTitleLabel.text = "Minimum Word Length"
            cell.settingsNumberLabel.text = String(rocketMan.wordMinLength)
            wordMinLengthLabel = cell.settingsNumberLabel
            wordMinLengthStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordMinimumLength(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
            cell.settingsStepper.value = Double(rocketMan.wordMinLength)
        case 3:
            cell.settingsTitleLabel.text = "Maximum Word Length"
            cell.settingsNumberLabel.text = String(rocketMan.wordMaxLength)
            wordMaxLengthLabel = cell.settingsNumberLabel
            wordMaxLengthStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordMaximumLength(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
            cell.settingsStepper.value = Double(rocketMan.wordMaxLength)
            
        default:
            break
        }
    }
    
    // MARK: - Stepper Helper Methods
    
    // MARK: - Triggered When the Difficulty Stepper is Tapped. Updates Difficulty Value
    @objc private func wordDifficulty(_ sender: UIStepper) {
        let newDifficultyValue = Int(sender.value)
        difficultyLabel.text = String(newDifficultyValue)
        rocketMan.difficulty = newDifficultyValue
    }
    
    // MARK: - Triggered when the word minimum stepper is tapped. Updates Word Minimum Legth Value
    @objc private func wordMinimumLength(_ sender: UIStepper) {
        let newWordMinimumLenghtValue = Int(sender.value)
        wordMinLengthLabel.text = String(newWordMinimumLenghtValue)
        rocketMan.wordMinLength = newWordMinimumLenghtValue
        
        // Update maximum word length if minimum word length exceeds it
        if (newWordMinimumLenghtValue > rocketMan.wordMaxLength) {
            wordMaxLengthLabel.text = String(newWordMinimumLenghtValue)
            wordMaxLengthStepper.value = Double(newWordMinimumLenghtValue)
        }
    }
    
    // MARK: - Triggered When the Word Maximum Stepper is Tapped. Updates Word Maximum Legth Value
    @objc private func wordMaximumLength(_ sender: UIStepper) {
        let newWordMaximumLenghtValue = Int(sender.value)
        wordMaxLengthLabel.text = String(newWordMaximumLenghtValue)
        rocketMan.wordMaxLength = newWordMaximumLenghtValue
        
        // Change mimum word length if maximum word length is lower
        if (newWordMaximumLenghtValue < rocketMan.wordMinLength) {
            wordMinLengthLabel.text = String(newWordMaximumLenghtValue)
            wordMinLengthStepper.value = Double(newWordMaximumLenghtValue)
        }
    }
    
    // MARK: - Triggered When Guess Stepper is Tapped. Updates Guess value
    @objc private func guessMaximum(_ sender: UIStepper) {
        let newGuessMaximumValue = Int(sender.value)
        guessMaximumLabel.text = String(newGuessMaximumValue)
        rocketMan.guessMaximum = newGuessMaximumValue
    }
    
    
}



