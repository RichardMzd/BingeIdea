//
//  Utilities.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 14/12/2023.
//

import Foundation
import UIKit

class Utilities: UIViewController {
    
    var iconClick = false
    
    static func styleTextField(_ textField: UITextField) {
        // Create the bottom line
        let bottomLine = UIView()
        
        // Set the background color of the bottom line
        bottomLine.backgroundColor = UIColor(named: "blueNavy")
        
        // Remove border on text field
        textField.borderStyle = .none
        
        // Add the line to the text field as a subview
        textField.addSubview(bottomLine)
        
        // Add constraints to position the bottom line
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -2).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    static func emailIcon(_ textField: UITextField) {
        let iconImage = UIImage(systemName: "envelope")
        let contentView = UIView()
        let imageIcon = UIImageView(image: iconImage)
        
        // Set the tint color
        imageIcon.tintColor = UIColor(named: "blueNavy")
        
        // Set a fixed size for the icon
        let iconSize = CGSize(width: 26, height: 20)
        
        contentView.addSubview(imageIcon)
        
        // Adjust the position of contentView
        contentView.frame = CGRect(x: -30, y: textField.frame.height - iconSize.height - 5, width: iconSize.width, height: iconSize.height)
        imageIcon.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        
        textField.rightView = contentView
        textField.rightViewMode = .always
    }
    
    static func styleHollowButton(_ button: UIButton) {
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "blueNavy")?.cgColor
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.backgroundColor = .white
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3.0
        
        // Utilisez une valeur fixe pour le coin arrondi
        let cornerRadius: CGFloat = button.bounds.size.height / 2.12
        //
        button.layer.cornerRadius = cornerRadius
        
        button.tintColor = UIColor(named: "blueNavy")
    }
    
    static func styleFilledButton(_ button: UIButton) {
        // Filled rounded corner style
        button.backgroundColor = UIColor(named: "blueNavy")
        button.tintColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3.0
        
        // Utilisez une valeur fixe pour le coin arrondi
        let cornerRadius: CGFloat = button.bounds.size.height / 2.12
        //
        button.layer.cornerRadius = cornerRadius
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
