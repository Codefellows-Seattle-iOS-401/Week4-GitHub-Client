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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        GitHubService.shared.tokenRequestFor(url: url, options: .userDefaults, completion: {(sucess) in
            
            
        })
        
        return true
    }

}

