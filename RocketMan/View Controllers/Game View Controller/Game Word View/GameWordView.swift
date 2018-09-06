//
//  GameWordView.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/29/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class GameWordView: UIView {
    
    // MARK: - Properties
    
    var labelArray = [UILabel]()
    var word: String?
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.alpha = 0.7
        self.backgroundColor = .white
        
        for _ in 0..<12 {
            let label = UILabel()
            label.font = UIFont(name: "HelveticaNeue-Medium", size: 24.0)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.text = "_"
            label.textColor = UIColor.black
            
            labelArray.append(label)
            
            self.addSubview(label)
        }
    }
    
    // MARK: - Drawing Underscores and Game Word
    
    override func draw(_ rect: CGRect) {
        guard let word = word else { return }
        
        if !word.isEmpty {
            let length = CGFloat(word.count)
            let spacing: CGFloat = 5.0
            let labelWidth: CGFloat = 20.0
            var margin = (self.frame.width - spacing * length - labelWidth * length) / 2
            margin += spacing / 2
            
            for index in 0..<Int(length) {
                let label = labelArray[index]
                let x = margin + labelWidth * CGFloat(index) + spacing * CGFloat(index)
                label.frame = CGRect(x: x, y: 0, width: labelWidth, height: self.frame.height)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func updateWord(_ array: [Character]) {
        for (index, character) in array.enumerated() {
            labelArray[index].text = String(character)
        }
    }
    
    func fillWord(_ array: [Character]) {
        for (index, character) in array.enumerated() {
            let letter = labelArray[index].text!
            if (letter == "_") {
                labelArray[index].text = String(character)
                labelArray[index].textColor = UIColor.red
            }
        }
    }
    
}
