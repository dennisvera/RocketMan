//
//  GameViewController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/28/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    var rocketMan: RocketMan?

    override func viewDidLoad() {
        super.viewDidLoad()
        
            print(self.rocketMan?.currentGame?.word ?? "Unable to Retrieve Word")
    }

}
