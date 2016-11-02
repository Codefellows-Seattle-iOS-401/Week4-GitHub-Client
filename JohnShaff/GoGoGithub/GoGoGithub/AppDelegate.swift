//
//  AppDelegate.swift
//  GoGoGithub
//
//  Created by John Shaff on 10/31/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var authController: AuthViewController?
    var homeController: HomeViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        checkAuthStatus()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        GitHubService.shared.tokenRequestFor(url: url, options: .userDefaults, completion: {(sucess) in
            
            //has to be an if let because these are optionals
            if let authController = self.authController, let homeController = self.homeController {
                authController.dismissAuthController()
                homeController.update()
            }
        })
        return true
    }
    
    func checkAuthStatus() {
        if let token = UserDefaults.standard.getAccessToken() {
            print(token)
        } else {
            
            // both of the options in the optional chain have to succeed in order to enter the lift statement
            if let navigationController = self.window?.rootViewController as? UINavigationController,
                let storyboard = navigationController.storyboard {
                
                //When we use the as we're saying even though we're instantiating as a ViewController we want it to be cast as an AuthViewController.
                if let authViewController = storyboard.instantiateViewController(withIdentifier: AuthViewController.identifier) as? AuthViewController{
                    
                    guard let homeViewController = navigationController.viewControllers[0] as? HomeViewController else { return }
                    
                    //We have to tell the parent it has a child
                    homeViewController.addChildViewController(authViewController)
                    
                    //We're adding the childs view hierarchy to the parents view
                    homeViewController.view.addSubview(authViewController.view)
                    
                    //The child has to know wzup
                    authViewController.didMove(toParentViewController: homeViewController)
                    
                    //Our app delegate now always has two references to these view controllers
                    self.authController = authViewController
                    self.homeController = homeViewController
                }
            }
        }
    }

}

