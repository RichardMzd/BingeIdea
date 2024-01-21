//
//  HomeViewController.swift
//  BingeIdea
//
//  Created by Richard Arif Mazid on 14/12/2023.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var userName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = userName {
            welcomeLabel.text = "Bienvenue \(name)"
            print(name)
        }
        
        // Utiliser une image système pour le bouton
        let systemImageName = "power" // Remplacez "nomImageSysteme" par le nom de l'image système souhaitée
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(logoutButtonTapped))
        
        // Ajuster la position du bouton dans la barre de navigation à droite
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "blueNavy")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    
    
    @objc func logoutButtonTapped() {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            print("Déconnexion réussie")
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        } catch let signOutError {
            print("Erreur de déconnexion: \(signOutError.localizedDescription)")
            self.present(Utilities.createAlertController(title: "Error", message: signOutError.localizedDescription), animated: true, completion: nil)
        }
    }
}
