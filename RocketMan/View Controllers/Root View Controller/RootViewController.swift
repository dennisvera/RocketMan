//
//  RootViewController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    let dataStore = ReachDataStore.sharedInstance
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        
        fetchWordsData()
    }
    
    // MARK: - Helper Method
    
    private func fetchWordsData() {
        dataStore.fetchWords { (success) in
            if success {
                print(self.dataStore.words.count)
                print(self.dataStore.words)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
    }
    
}


// MARK: - UITableView Data Source

extension RootViewController: UITableViewDataSource {
    
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
    
    private func configure(_ cell: SettingsTableViewCell, at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.settingsTitleLabel.text = "Difficulty"
            cell.settingsNumberLabel.text = "1"
            cell.settingsStepper.maximumValue = 10
            cell.settingsStepper.minimumValue = 1
            break
        case 1:
            cell.settingsTitleLabel.text = "Minimum Word Length"
            cell.settingsNumberLabel.text = "2"
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
        case 2:
            cell.settingsTitleLabel.text = "Maximum Word Length"
            cell.settingsNumberLabel.text = "3"
            cell.settingsStepper.maximumValue = 12
            cell.settingsStepper.minimumValue = 2
        default:
            break
        }
    }
    
}

// MARK: - UITableView Data Delegate

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

