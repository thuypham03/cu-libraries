//
//  MainController.swift
//  CULibraries
//
//  Created by 过仲懿 on 5/2/22.
//

import Foundation
import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate f,or that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "login_bg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // Create Libraries
        let libraryPage = UINavigationController(rootViewController: LibraryController())
        let libraryPageBarItem = UITabBarItem(title: "Libraries", image: UIImage(systemName: "list.bullet"), tag: 0)
        libraryPage.tabBarItem = libraryPageBarItem
        
        // Create Reservations
        let accountPage = UINavigationController(rootViewController: AccountController())
        let accountPageBarItem = UITabBarItem(title: "Reservations", image: UIImage(systemName: "calendar"), tag: 0)

        accountPage.tabBarItem = accountPageBarItem
        self.tabBar.tintColor = UIColor(hexString: "#B31B1B")
        self.tabBar.backgroundColor = .systemBackground
        self.viewControllers = [libraryPage, accountPage]
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        
        // TODO: Change this!
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(hexString: "#B31B1B")
        appearance.backgroundColor = UIColor(hexString: "#F23E3E")
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationBar.isTranslucent = true
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
