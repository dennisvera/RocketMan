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

    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        print(rocketMan?.currentGame.customMirror ?? "Unable To Reach Current Game")
        print(rocketMan?.currentGame?.word ?? "NO WORD ...cry cry cry")
        print(rocketMan?.currentGame?.wordArray ?? "NO WORD ARRAY...cry cry cry")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
}










