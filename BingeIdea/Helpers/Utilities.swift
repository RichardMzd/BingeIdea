//
//  Utilities.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 14/12/2023.
//

import Foundation
import UIKit

class Utilities {
    
    var iconClick = false

    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor(named: "blueNavy")?.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func emailIcon(_ textfield: UITextField) {
        let iconImage = UIImage(named: "email")
        let contentView = UIView()
        let imageIcon = UIImageView(image: iconImage)
        // Set the original size or a default size if the image is nil
        let iconWidth = iconImage?.size.width ?? 24
        let iconHeight = iconImage?.size.height ?? 24

        // Adjust the size of the icon (e.g., multiply by 1.2 to increase by 20%)
        let enlargedWidth = iconWidth * 0.7
        let enlargedHeight = iconHeight * 0.7
        
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: enlargedWidth, height: enlargedHeight)
        imageIcon.frame = CGRect(x: -20, y: -5, width: enlargedWidth, height: enlargedHeight)
        
        textfield.rightView = contentView
        textfield.rightViewMode = .always
    }
    
   
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor(named: "blueNavy")
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "blueNavy")?.cgColor
        button.layer.cornerRadius = 20
        button.tintColor = UIColor(named: "blueNavy")
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            
            return alert
        }

    
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z\\d@$#!%*?&]).{8,}$"
        print("Original password: \(password)")

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        if passwordTest.evaluate(with: password) == false {
            print("Password validation failed for: \(password)")
            print("Match result: \(passwordTest.evaluate(with: password))")
        }

        return passwordTest.evaluate(with: password)
    }
}
