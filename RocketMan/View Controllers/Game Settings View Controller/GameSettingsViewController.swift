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
    var wordMinLengthLabel: UILabel!
    var wordMinLengthStepper: UIStepper!
    var wordMaxLengthLabel: UILabel!
    var wordMaxLengthStepper: UIStepper!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
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
        if segue.identifier == "GameViewController" {
            let destination = segue.destination as! GameViewController
            destination.rocketMan = rocketMan
        }        
    }
        
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: Any) {
        rocketMan.startRocketManGame()
        
        // Wait for response from URL session
        while (rocketMan.urlError == .waiting) { }
        // Check if there is an error in obtaining a word with the given parameters
        if (rocketMan.urlError == .noWord) {
            let noWordAlert = UIAlertController(title: "No Word Found", message: "Change difficulty or word length and try again.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            noWordAlert.addAction(okButton)
            present(noWordAlert, animated: true, completion: nil)
            return
            
            // Check if there is an error in reaching the server
        } else if (rocketMan.urlError == .noResponse) {
            let noResponseAlert = UIAlertController(title: "Server Unavailable", message: "Make sure you are connected to the internet.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            noResponseAlert.addAction(okButton)
            present(noResponseAlert, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "GameViewController", sender: self)
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
            cell.settingsNumberLabel.text = String(rocketMan.wordMinLength)
            wordMinLengthLabel = cell.settingsNumberLabel
            wordMinLengthStepper = cell.settingsStepper
            cell.settingsStepper.addTarget(self, action: #selector(wordMinimumLength(_:)), for: .allTouchEvents)
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
            cell.settingsStepper.value = Double(rocketMan.wordMinLength)
        case 2:
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
    
    // MARK: - Difficulty Stepper Updates Difficulty Value
    @objc private func wordDifficulty(_ sender: UIStepper) {
        let newDifficultyValue = Int(sender.value)
        difficultyLabel.text = String(newDifficultyValue)
        rocketMan.difficulty = newDifficultyValue
    }
    
    // MARK: - Word Minimum Stepper Updates Word Minimum Legth Value
    @objc private func wordMinimumLength(_ sender: UIStepper) {
        let newWordMinimumLenghtValue = Int(sender.value)
        wordMinLengthLabel.text = String(newWordMinimumLenghtValue)
        rocketMan.wordMinLength = newWordMinimumLenghtValue
        
        // Updates maximum word length if minimum word length exceeds it
        if (newWordMinimumLenghtValue > rocketMan.wordMaxLength) {
            wordMaxLengthLabel.text = String(newWordMinimumLenghtValue)
            wordMaxLengthStepper.value = Double(newWordMinimumLenghtValue)
            rocketMan.wordMaxLength = newWordMinimumLenghtValue
        }
    }
    
    // MARK: - Word Maximum Stepper Updates Word Maximum Legth Value
    @objc private func wordMaximumLength(_ sender: UIStepper) {
        let newWordMaximumLenghtValue = Int(sender.value)
        wordMaxLengthLabel.text = String(newWordMaximumLenghtValue)
        rocketMan.wordMaxLength = newWordMaximumLenghtValue
        
        // Updates minimum word length if maximum word length exceeds it
        if (newWordMaximumLenghtValue < rocketMan.wordMinLength) {
            wordMinLengthLabel.text = String(newWordMaximumLenghtValue)
            wordMinLengthStepper.value = Double(newWordMaximumLenghtValue)
            rocketMan.wordMinLength = newWordMaximumLenghtValue
        }
    }
    
}

