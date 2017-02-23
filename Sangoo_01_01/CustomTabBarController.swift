//
//  CustomTabBarController.swift
//  RealmTasksTutoiral
//
//  Created by Florenz Erstling on 27.01.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        
        let connectController = InstantContactViewTableViewController()
        let navController = ContactTableViewController()
        let settingController = SettingsTableViewController()
        let connectNavController = createTabElement(controller: connectController, navTitle : "Gruppen", imageName: "connect")
        let contactNavController = createTabElement(controller: navController, navTitle : "Contacts", imageName: "contacts")
        let settingNavController = createTabElement(controller: settingController, navTitle : "Settings", imageName: "settings")
        
        
        viewControllers = [connectNavController, contactNavController, settingNavController]
        //tabBarController?.viewControllers = [settingNavController,connectNavController, contactNavController]
        //viewControllers = [settingNavController,connectNavController, contactNavController]
        //viewControllers = [contactNavController, connectNavController, settingNavController]
        
        
        //setup login
       

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let userId = UserDefaults.standard.string(forKey: "isUserLoggedIn")
//        print(userId)
//        if (userId?.characters.count == 0){
//            print("nicht Eingeloggtt")
//            //let loginView = LoginTableViewController()
//            //let loginNavController = UINavigationController(rootViewController: loginView)
//            goBackToLandingPage()
//        }
//    }
//    
    func createTabElement(controller: UITableViewController, navTitle : String, imageName: String) -> UINavigationController {
    
        let connectNavController = UINavigationController(rootViewController: controller)
        connectNavController.tabBarItem.title = navTitle
        connectNavController.tabBarItem.image = UIImage(named:imageName)
        
        return connectNavController
    
    }
    
    func goBackToLandingPage(){
        
        print("goBack")

        let v = LandingPageTableViewController()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        navigationController?.pushViewController(v, animated: true)
        
    }

    
}
