//
//  SignUpViewController.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 14/12/2023.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var iconClick = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.emailIcon(emailTextField)
        hideAndShowPassword(passwordTextField)
        setupElements()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func hideAndShowPassword(_ textfield: UITextField) {
        let iconImage = UIImage(named: "hide")
        let contentView = UIView()
        let imageIcon = UIImageView(image: iconImage)
        // Set the original size or a default size if the image is nil
        let iconWidth = iconImage?.size.width ?? 24
        let iconHeight = iconImage?.size.height ?? 24

        // Adjust the size of the icon (e.g., multiply by 1.2 to increase by 20%)
        let enlargedWidth = iconWidth * 0.8
        let enlargedHeight = iconHeight * 0.8
        
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: enlargedWidth, height: enlargedHeight)
        imageIcon.frame = CGRect(x: -5, y: 0, width: enlargedWidth, height: enlargedHeight)
        
        textfield.rightView = contentView
        textfield.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
            let tappedImage = tapGestureRecognizer.view as? UIImageView

        if iconClick {
            iconClick = false
                tappedImage?.image = UIImage(named: "eye")
                passwordTextField.isSecureTextEntry = false
            } else {
                iconClick = true
                tappedImage?.image = UIImage(named: "hide")
                passwordTextField.isSecureTextEntry = true
            }
        }
    
    func setupElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method return nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return LoginErrors.fillFields
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // there's something wrong with the fields, show error message
            showError(error!)
        } else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                } else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["firstname" : firstName, "lastname" : lastName, "uid" : result!.user.uid]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
                    self.fetchUserFromDatabase()
                }
            }
        }
    }
    
    func fetchUserFromDatabase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Utilisateur non authentifié")
            return
        }

        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")

        usersCollection.whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Erreur lors de la récupération du document: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("Le document n'existe pas.")
                return
            }

            // Si plusieurs documents correspondent, utilisez le premier
            let document = documents[0]

            if let firstName = document["firstname"] as? String,
               let lastName = document["lastname"] as? String {
                print("FirstName from database: \(firstName)")
                print("LastName from database: \(lastName)")
                self.showHomeViewController(firstName: firstName, lastName: lastName)
            } else {
                print("Le document ne contient pas les propriétés 'firstname' et/ou 'lastname'")
            }
        }
    }
    
    func showHomeViewController(firstName: String, lastName: String) {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        // Passer le prénom à HomeViewController
        homeViewController?.userName = "\(firstName) \(lastName)"
        
        if let homeViewController = homeViewController {
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
