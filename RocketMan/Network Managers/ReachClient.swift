//
//  ReachClient.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class ReachClient {
    
    // MARK: - Types
    
    typealias ReachData = String
    
    // MARK: - Requesting Data
    
    class func fetchReachData(difficulty: String, wordMinLength: String, wordMaxLength: String, completionHandler: @escaping (ReachData) -> ()) {
        let urlString = "http://app.linkedin-reach.io/words?difficulty=\(difficulty)&minLength=\(wordMinLength)&maxLength=\(wordMaxLength)"
        
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let urlRequest = URLRequest(url: url)
        
        // Create Data Task
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response Status Code: \(response.statusCode)\n")
            }
            
            if let error = error {
                print("Unable To Fetch Reach Data: \(error)\n")
            } else {
                DispatchQueue.global(qos: .background).async {
                    guard let data = data else { fatalError("Unable to get data: \(String(describing: error?.localizedDescription))") }
                    
                    let reachData = String(decoding: data, as: UTF8.self)
                    let reachDataWords = reachData.components(separatedBy: CharacterSet.newlines)
                    let index = Int(arc4random_uniform(UInt32(reachDataWords.count)))
                    let selectedGameWord = reachDataWords[index]
                    
                    if selectedGameWord != "" {
                        completionHandler(selectedGameWord)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
}
