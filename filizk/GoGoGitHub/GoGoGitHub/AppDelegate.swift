//
//  AppDelegate.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 10/31/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let parameters = ["scope":"user:email,repo"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if GitHubService.shared.checkIfValidTokenExists() == nil {
            GitHubService.shared.oAuthWith(parameters: parameters)
        }

        return true
    }

    //enter point when github redirects
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)

/* try? below says GitHubService can return a nil (although it's not returning optional), and it will be made into an optinal at the return here by try?
        //let code = try? GitHubService.shared.codeFrom(url: url)

        //other option is to try/catch block
        do {
            let code = try GitHubService.shared.codeFrom(url: url)

            print(code)
        } catch {
            print(error)

        }
 */
        GitHubService.shared.tokenRequestFor(url: url, options: .userDefaults) { (success) in
                
        }

        return true
    }
}

