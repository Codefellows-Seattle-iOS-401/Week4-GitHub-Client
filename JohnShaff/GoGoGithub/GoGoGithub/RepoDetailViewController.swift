//
//  RepoDetailViewController.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/2/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    @IBOutlet weak var repoName: UILabel!
    
    @IBOutlet weak var repoFork: UILabel!
    
    @IBOutlet weak var repoLanguage: UILabel!
    
    @IBOutlet weak var repoWatchers: UILabel!
    
    @IBOutlet weak var repoDescription: UILabel!
    
    var repo: Repository!

    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repoName.text = repo.name
        if repo.fork {
            repoFork.text = "Forked"
        } else {
            repoFork.text = "Unforked"
        }
        repoLanguage.text = repo.language
        
        if let watchers = repo.watchers {
            repoWatchers.text = String(describing: watchers)
        }
        
        repoDescription.text = repo.description
    }

}
