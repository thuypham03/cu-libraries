//
//  LoginController.swift
//  CULibraries
//
//  Created by 过仲懿 on 2022-04-28.
//
import Foundation
import UIKit

class LoginController: UIViewController {
    var logo = UIImageView()
//    var loginLabel = UILabel()
//    var subtitle = UILabel()
    let usernameField = Input(title: "Username")
    let passwordField = Input(title: "Password")
    
    lazy var loginButton = UIButton()
    
    override func viewDidLoad() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "login_bg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)

        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        loginButton.setTitle("Login", for:.normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 20)
        loginButton.layer.cornerRadius = 27
        loginButton.backgroundColor = UIColor(hexString: "#E02424")
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        usernameField.placeholder = "NetID"
        passwordField.placeholder = "Password"
        
        loginField()

        
        [usernameField, passwordField, usernameField, loginButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            usernameField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.widthAnchor.constraint(equalToConstant: 270),
            usernameField.heightAnchor.constraint(equalToConstant: 55),
            
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 270),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            loginButton.widthAnchor.constraint(equalToConstant: 180),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func loginField() {
        passwordField.isSecureTextEntry = true
        
        usernameField.textAlignment = .center
        usernameField.textColor = .black
        
        passwordField.textAlignment = .center
        passwordField.textColor = .black
        
        usernameField.backgroundColor = .systemBackground
        passwordField.backgroundColor = .systemBackground
        
//        usernameField.reflect
        
        usernameField.layer.masksToBounds = true
//        usernameField.layer.borderWidth = 2
        usernameField.layer.borderColor = UIColor.gray.cgColor
        
        passwordField.layer.masksToBounds = true
        passwordField.layer.shadowColor = UIColor.gray.cgColor
//        passwordField.layer.borderWidth = 2
        passwordField.layer.borderColor = UIColor.gray.cgColor
        
        usernameField.autocapitalizationType = .none
        passwordField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        passwordField.autocorrectionType = .no
        
        usernameField.layer.cornerRadius = 27
        passwordField.layer.cornerRadius = 27
    }
    
    @objc func login() {
        if let username = usernameField.decodeText(), let password = passwordField.decodeText() {
            LoginManager.username = username
            LoginManager.password = password
            navigationController?.popViewController(animated: true)

            // Implement logic
        }
//        } else {
//            let _ = usernameField.validate()
//            let _ = passwordField.validate()
//        }
    }
}
