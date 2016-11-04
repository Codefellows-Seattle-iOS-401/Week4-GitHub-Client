//
//  UserSearchViewController.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/3/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit
import SafariServices

class UserSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchedUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //We always store the delegate in the property
        self.searchBar.delegate = self
        

    }
}

//Conforming to the
extension UserSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //if there's valid text on the search bar
        if let searchText = searchBar.text {
            GitHubService.shared.searchUsersWith(searchTerm: searchText, completion: { (results) in
                if let results = results {
                    self.searchedUsers = results
                }
            })
        }
        //this manually dismisses the keyboard
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isValid {
            
            //This is going to get the index of the very last character that was added.
            let lastIndex = searchText.index(before: searchText.endIndex)
            
            //
            searchBar.text = searchText.substring(to: lastIndex)
        }
    }
}

//We need to extend the class to get these methods
extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // IndexPath is a struct with all kinds of stuff on it.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print(indexPath)
        let currentUser = self.searchedUsers[indexPath.row]
        
        cell.textLabel?.text = currentUser.login
        return cell
    }
    
    //This builds the rows based on the available data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = self.searchedUsers[indexPath.row]
        
//        presentWebControllerWith(url: selectedUser.webUrl)
        presentSafarViewControllerWith(url: selectedUser.webUrl)
    }
    
    //putting this method in the extension, even though we're going to have to call it, because we're calling it within another extension method that we're NOT CALLING.
    func presentWebControllerWith(url: String) {
        let webViewController = WebViewController()
        webViewController.webURL = url
        self.present(webViewController, animated: true, completion: nil)
    }
    
    //This is just a wrapper that provides all kinds of cool stuff from Safari.
    func presentSafarViewControllerWith(url: String) {
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        
        self.present(safariViewController, animated: true, completion: nil)
    }
    
}
