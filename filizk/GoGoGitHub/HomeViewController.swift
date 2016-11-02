//
//  HomeViewController.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 11/1/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var repositoryList = [Repository]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.searchBar.delegate = self

        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func update() {
        GitHubService.shared.fetchRepos {(repositories) in
            if let repositories = repositories {
                self.repositoryList = repositories
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryListCell")

        cell?.textLabel?.text = repositoryList[indexPath.row].name
        cell?.detailTextLabel?.text = repositoryList[indexPath.row].description

        return cell!
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        repositoryList = repositoryList.filter { (repository) -> Bool in
            return repository.name.contains(searchBar.text!)
        }

    }
}



