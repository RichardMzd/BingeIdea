//
//  LoginViewController.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 14/12/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
  
    var iconClick = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        Utilities.emailIcon(emailTextField)
        hideAndShowPassword(passwordTextField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        emailTextField.text = ""
        passwordTextField.text = ""
        errorLabel.alpha = 0
    }
    
    func hideAndShowPassword(_ textField: UITextField) {
       let iconImage = UIImage(systemName: "eye")
       let contentView = UIView()
       let imageIcon = UIImageView(image: iconImage)
       
       // Set the tint color
       imageIcon.tintColor = UIColor(named: "blueNavy")
       
       // Set a fixed size for the icon
       let iconSize = CGSize(width: 26, height: 22)
       
       contentView.addSubview(imageIcon)
       
       // Adjust the position of contentView
       contentView.frame = CGRect(x: -30, y: textField.frame.height - iconSize.height - 5, width: iconSize.width, height: iconSize.height)
       imageIcon.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
       
       textField.rightView = contentView
       textField.rightViewMode = .always
       
       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
       tapGestureRecognizer.numberOfTapsRequired = 1
       tapGestureRecognizer.cancelsTouchesInView = false
       imageIcon.isUserInteractionEnabled = true
       imageIcon.addGestureRecognizer(tapGestureRecognizer)
   }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as? UIImageView

        if iconClick {
            iconClick = false
            tappedImage?.image = UIImage(systemName: "eye")
            passwordTextField.isSecureTextEntry = true
        } else {
            iconClick = true
            tappedImage?.image = UIImage(systemName: "eye.slash")
            passwordTextField.isSecureTextEntry = false
        }
    }

    
    func setupElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Valider les champs de texte
        
        // Créer des versions nettoyées des champs de texte
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Connexion de l'utilisateur
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Impossible de se connecter
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                // Récupérer le prénom de la base de données Firebase
                if let targetUID = result?.user.uid {
                    print("Target UID: \(targetUID)")
                    self.fetchUserFromDatabase()
                } else {
                    print("Erreur: Impossible de récupérer l'UID de l'utilisateur.")
                }
            }
        }
    }
    
    
    func fetchUserFromDatabase() {
        
        // Vérifie que l'utilisateur est connecté et récupère son UID
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Utilisateur non authentifié")
            return
        }

        // Accède à l'instance Firestore
        let db = Firestore.firestore()
        
        // Accède à la collection "Users"
        let usersCollection = db.collection("Users")
        // Effectue une requête pour trouver le document avec le champ "uid" égal à l'UID de l'utilisateur actuel
        usersCollection.whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            // Gère les erreurs potentielles lors de la récupération des documents
            if let error = error {
                print("Erreur lors de la récupération du document: \(error.localizedDescription)")
                return
            }
            // Vérifie si des documents ont été trouvés dans la requête
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("Le document n'existe pas.")
                return
            }
            // Si plusieurs documents correspondent, utilisez le premier
            let document = documents[0]

            // Extrait les propriétés "firstname" et "lastname" du document
            if let firstName = document["firstname"] as? String,
               let lastName = document["lastname"] as? String {
                print("FirstName from database: \(firstName)")
                print("LastName from database: \(lastName)")
                
                // Appelle la fonction pour afficher la vue home avec les données extraites
                self.showHomeViewController(firstName: firstName)
            } else {
                // Si les propriétés attendues ne sont pas présentes dans le document
                print("Le document ne contient pas les propriétés 'firstname' et/ou 'lastname'")
            }
        }
    }


    
    
    
    
    
    func showHomeViewController(firstName: String) {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        // Passer le prénom à HomeViewController
        homeViewController?.userName = "\(firstName)"
        
        if let homeViewController = homeViewController {
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    
}


