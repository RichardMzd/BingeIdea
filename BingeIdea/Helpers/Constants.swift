//
//  Constants.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 15/12/2023.
//

import Foundation


struct Constants {
    
    struct Storyboard {
        
       static let homeViewController = "HomeVC"
    }
}

@objc protocol PasswordToggleable: NSObjectProtocol {
    func togglePasswordVisibility()
}
