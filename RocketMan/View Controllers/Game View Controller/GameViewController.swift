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
    
    // MARK: - Properties
    
    var rocketMan: RocketMan?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
            print(rocketMan?.currentGame?.word ?? "Unable to Retrieve Word")
        
    }

}
