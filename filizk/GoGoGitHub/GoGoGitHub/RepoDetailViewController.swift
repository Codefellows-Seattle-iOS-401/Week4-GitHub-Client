//
//  RepoDetailViewController.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 11/2/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var openIssues: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var language: UILabel!

    //instance of repo is being sent
    var repository: Repository? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateRepositoryInfoUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    func populateRepositoryInfoUI() {
        if let repository = repository {
            self.name.text = repository.name
            self.desc.text = repository.description
            if repository.openIssues != nil {
                self.openIssues.text = repository.openIssues! ? "Yes" : "No"
            } else {
                 self.openIssues.text = "Open Issues: None"
            }
            self.createdAt.text = repository.createdAt
            self.language.text = repository.language
        }
    }
}
