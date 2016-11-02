//
//  HomeViewController.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/1/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let customTransition = CustomTransition()
    var filteredRepos = [Repository]()
    
    @IBOutlet weak var repoTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        update()
        let nib = UINib(nibName: "repoCell", bundle: nil)
        self.repoTableView.register(nib, forCellReuseIdentifier: repo)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //This is goig to force update from all the repos
    func update() {
        GitHubService.shared.fetchRepos { (repositories) in
            if let repositories = repositories {
                GitHubService.shared.allRepos = repositories
                self.repoTableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == RepoDetailViewController.identifier {
            if let destinationController = segue.destination as? RepoDetailViewController {
                destinationController.transitioningDelegate = self
            }
        }
    }


}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repoName = GitHubService.shared.allRepos[indexPath.row].name
        cell.textLabel?.text = repoName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GitHubService.shared.allRepos.count
    }
    
}
//
