//
//  ReachClient.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/26/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import Foundation

class ReachClient {
    
    typealias ReachData = [String]
    
    // MARK: - Requesting Data
    
    class func fetchReachData(completionHandler: @escaping (ReachData) -> ()) {
        let urlString = "http://app.linkedin-reach.io/words?difficulty=8"
        
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
                guard let data = data else { fatalError("Unable to get data: \(String(describing: error?.localizedDescription))") }
                
                let reachData = String(decoding: data, as: UTF8.self)
                completionHandler([reachData])
            }
        }
        
        dataTask.resume()
    }
    
}
