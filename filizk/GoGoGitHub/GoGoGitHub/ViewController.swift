//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 10/31/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // UserDefaults.standard.resetToken()
    }



    @IBAction func requestTokenPressed(_ sender: AnyObject) {
        let parameters = ["scope":"user:email,repo"]

        if GitHubService.shared.checkIfValidTokenExists() == nil {
            GitHubService.shared.oAuthWith(parameters: parameters)
        }
    }

    @IBAction func printTokenButtonPressed(_ sender: AnyObject) {
        if let token = GitHubService.shared.checkIfValidTokenExists() {
           print("ACCESS_TOKEN: ", token)
        }
    }
}

