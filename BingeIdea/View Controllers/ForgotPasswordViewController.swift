//
//  ForgotPasswordViewController.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 03/01/2024.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        Utilities.styleFilledButton(sendButton)
        Utilities.styleTextField(emailTextField)
        Utilities.emailIcon(emailTextField)
    }
    
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailTextField.text ?? "") { (error) in
            if let error = error {
                let alert = Utilities.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let alert = Utilities.createAlertController(title: "Success", message: "A password reset email has been sent!")
            self.present(alert, animated: true, completion: nil)

        }
    }
    
   

}
