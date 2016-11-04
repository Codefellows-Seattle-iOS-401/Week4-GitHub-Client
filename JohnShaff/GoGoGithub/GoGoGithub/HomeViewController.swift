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
    
    @IBOutlet weak var repoSearchBar: UISearchBar!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        update()
        
        //ANY TIME WE USE A NIB WE HAVE TO REGISTER 
        let nib = UINib(nibName: "repoCell", bundle: nil)
        self.repoTableView.register(nib, forCellReuseIdentifier: RepoViewCell.identifier)
        
        //THIS DOES SOMETHING SPECIAL THAT I NEED TO REMEMBER BUT I DONT REMEMBER WHAT
        self.repoTableView.estimatedRowHeight = 50
        self.repoTableView.rowHeight = UITableViewAutomaticDimension
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
                self.filteredRepos = GitHubService.shared.allRepos
                self.repoTableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let selectedIndex = repoTableView.indexPathForSelectedRow!.row
        let selectedRepo = GitHubService.shared.allRepos[selectedIndex]
        
        if segue.identifier == RepoDetailViewController.identifier {
            if let destinationController = segue.destination as? RepoDetailViewController {
                destinationController.transitioningDelegate = self
                destinationController.repo = selectedRepo
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            filteredRepos = [Repository]()
            for repo in GitHubService.shared.allRepos {
                if repo.name == searchText {
                    filteredRepos.append(repo)
                }
            }
            self.repoTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.repoTableView.reloadData()
        update()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoViewCell.identifier, for: indexPath) as! RepoViewCell
        let repoName = filteredRepos[indexPath.row]
        cell.repo = repoName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sender is whoever fired off the method... it can hand something over to the prepareForSegue which checks for it.
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
    
}
//
