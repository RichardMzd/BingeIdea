//
//  ViewController.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 14/12/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)

    }
    
    
    
}

