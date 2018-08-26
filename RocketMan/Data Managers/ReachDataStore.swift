//
//  ReachDataStore.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class ReachDataStore {
    
    // MARK: - Properties
    
    static let sharedInstance = ReachDataStore()
    var words = [String]()
    
    // MARK: - Requesting & Parsing Data
    
    func fetchWords(completionHandler: @escaping (Bool) -> ()) {
        
        ReachClient.fetchReachData { (words) in
            for word in words {
                self.words.append(word)
                
                print(self.words)
            }
        }
        
        if self.words.count > 0 {
            completionHandler(true)
        }
    }
    
}
