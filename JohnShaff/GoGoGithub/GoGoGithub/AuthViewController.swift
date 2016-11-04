//
//  AuthViewController.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/1/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let parameters = ["scope": "user:email,repo"]
        GitHubService.shared.oAuthWith(parameters:parameters)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //The ordering matters (parents & child are used for controllers, and super & sub with views)
    func dismissAuthController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    



}
