//
//  KeyboardView.swift
//  RocketMan
//
//  Created by Dennis Vera on 8/28/18.
//  Copyright © 2018 Dennis Vera. All rights reserved.
//

import UIKit

class KeyboardView: UIView {
    
    // MARK: - Properties
    
    var buttons = [KeyboardButton]()
    let characters: [Character] = ["Q","W","E","R","T","Y","U","I","O","P",
                                   "A","S","D","F","G","H","J","K","L",
                                   "Z","X","C","V","B","N","M"]
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
        for character in characters {
            let newButton = KeyboardButton()
            newButton.setTitle(String(character), for: UIControlState.normal)
            newButton.setTitleColor(UIColor.lightGray, for: .highlighted)
            newButton.setTitleColor(UIColor.black, for: .normal)
            newButton.backgroundColor = UIColor.groupTableViewBackground
            newButton.isEnabled = true
            newButton.key = character
            
            buttons.append(newButton)
            self.addSubview(newButton)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        for character in characters {
            let newButton = KeyboardButton()
            newButton.setTitle(String(character), for: UIControlState.normal)
            newButton.setTitleColor(UIColor.lightGray, for: .highlighted)
            newButton.setTitleColor(UIColor.black, for: .normal)
            newButton.backgroundColor = UIColor.groupTableViewBackground
            newButton.isEnabled = true
            newButton.key = character
            
            buttons.append(newButton)
            self.addSubview(newButton)
        }
    }
    
    // MARK: - Draw Buttons
    
    override func draw(_ rect: CGRect) {
        let width = self.frame.width
        
        let rowSpacing: CGFloat = 10.0
        let spacing: CGFloat = 2.0
        let buttonWidth = (width - spacing * 10) / 10
        let buttonHeight = buttonWidth * 1.5
        
        // First row
        for index in 0..<10 {
            let button = buttons[index]
            let x = spacing + buttonWidth * CGFloat(index) + spacing * CGFloat(index)
            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: buttonHeight)
        }
        
        // Second row
        for index in 10..<19 {
            let button = buttons[index]
            let adjustedIndex = index - 10
            let extraSpace = buttonWidth / 2 + spacing
            let x = extraSpace + buttonWidth * CGFloat(adjustedIndex) + spacing * CGFloat(adjustedIndex)
            button.frame = CGRect(x: x, y: buttonHeight + rowSpacing, width: buttonWidth, height: buttonHeight)
        }
        
        // Third row
        for index in 19..<26 {
            let button = buttons[index]
            let adjustedIndex = index - 19
            let extraSpace = buttonWidth / 2 + spacing * 18
            let x = extraSpace + buttonWidth * CGFloat(adjustedIndex) + spacing * CGFloat(adjustedIndex)
            button.frame = CGRect(x: x, y: buttonHeight * 2 + rowSpacing * 2, width: buttonWidth, height: buttonHeight)
        }
    }
    
}
