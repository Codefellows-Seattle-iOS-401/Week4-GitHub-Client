//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 11/1/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    let customTransition = CustomTransition()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var repositoryList = [Repository]() {
        didSet {
            tableView.reloadData()
        }
    }

    var repositoryListCopy = [Repository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self

        update()

        self.tableView.estimatedRowHeight = 125
        self.tableView.rowHeight = UITableViewAutomaticDimension

        let nib = UINib(nibName: "RepoDetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "RepoDetailCell")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == RepoDetailViewController.identifier {
            if let destinationController = segue.destination as? RepoDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destinationController.repository = repositoryList[indexPath.row]
                    destinationController.transitioningDelegate = self
                }
            }
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }


    func update() {
        GitHubService.shared.fetchRepos {(repositories) in
            if let repositories = repositories {
                self.repositoryList = repositories
                self.repositoryListCopy = self.repositoryList
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoDetailCell") as! RepoDetailCell

        cell.name.text = repositoryList[indexPath.row].name
        cell.desc.text = repositoryList[indexPath.row].name

        //cell?.textLabel?.text = repositoryList[indexPath.row].name
        //cell?.detailTextLabel?.text = repositoryList[indexPath.row].description

        return cell
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        repositoryList = repositoryList.filter { (repository) -> Bool in
            return repository.name.contains(searchBar.text!)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            repositoryList = repositoryListCopy.filter { (repository) -> Bool in
                return repository.name.contains(searchText)
                }
        } else {
            repositoryList = repositoryListCopy

           self.searchBar.endEditing(true)
        }
    }

//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
 //       tableView.reloadData()
 //   }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
}





