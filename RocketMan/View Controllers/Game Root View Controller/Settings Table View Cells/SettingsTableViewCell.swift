//
//  SettingsTableViewCell.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "SettingsTableViewCell"

    // MARK: - Outlets
    
    @IBOutlet var settingsTitleLabel: UILabel!
    @IBOutlet var settingsNumberLabel: UILabel!
    @IBOutlet var settingsStepper: UIStepper!
    
    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
