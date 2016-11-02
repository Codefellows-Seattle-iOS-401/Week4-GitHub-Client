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

    var authController: AuthViewController?
    var homeController: HomeViewController?

    let parameters = ["scope":"user:email,repo"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //UserDefaults.standard.resetToken()
        checkAuthStatus()
        return true
    }

    func checkAuthStatus() {
        if let token = UserDefaults.standard.getAccessToken() {
            print (token)
        } else {
            if let homeViewController = self.window?.rootViewController as? HomeViewController,
                let storyboard = homeViewController.storyboard {

                if let authViewController = storyboard.instantiateViewController(withIdentifier: "authVC") as? AuthViewController {
                    homeViewController.addChildViewController(authViewController)
                    homeViewController.view.addSubview(authViewController.view)

                    authViewController.didMove(toParentViewController: homeViewController)

                    self.authController = authViewController
                    self.homeController = homeViewController
                }
            }
        }
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
            if let authController = self.authController, let homeController = self.homeController {
                authController.dismissAuthController()
                homeController.update()
            }
        }

        return true
    }
}

