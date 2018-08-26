//
//  RootViewController.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Properties
    
    let dataStore = ReachDataStore.sharedInstance
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataStore.fetchWords { (success) in
            if success {
                print(self.dataStore.words.count)
                print(self.dataStore.words)
            }
        }
    }

}

