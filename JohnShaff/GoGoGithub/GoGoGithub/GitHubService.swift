//
//  GitHubService.swift
//  GoGoGithub
//
//  Created by John Shaff on 10/31/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

let kBaseUrlString = "https://github.com/login/oauth/"

typealias GitHubAuthCompletion = (Bool) -> ()
typealias RepositoriesCompletion = ([Repository]?)->()
typealias UserSearchCompletion = ([User]?) -> ()
typealias RepoSearchCompletion = ([Repository]?) -> ()


enum GitHubOAuthError: Error {
    case extractingCode(String)
}


enum SaveOptions {
    case userDefaults
    
}


class GitHubService {
    
    //this right here is the actual singleton
    static let shared = GitHubService()
    
    private var session: URLSession
    private var urlComponents: URLComponents
    
    var allRepos = [Repository]()

    
    private func configure() {
        
        // we're using urlComponents as a class that already exists with these helpful properties to store URL stuff
        self.urlComponents.scheme = "https"
        
        //this is completing our url in chunks
        self.urlComponents.host = "api.github.com"
        
        if let token = UserDefaults.standard.getAccessToken() {
            let tokenQueryItem = URLQueryItem(name: "access_token", value: token)
            
            //Building out the url query items array
            urlComponents.queryItems = [tokenQueryItem]
        }
    }
    
    
    //NETWORK CALL: pagination on an endpoint means its only returning a certain amount of the total data available
    func searchUsersWith(searchTerm: String, completion: @escaping UserSearchCompletion) {
        self.urlComponents.path = "/search/users"
        
        //Adding to the url query items array... doesn't matter what order. Server will parse and return all query items.
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        
        self.urlComponents.queryItems?.append(searchQueryItem)
        
        guard let url = self.urlComponents.url else { completion(nil); return }
        
        self.session.dataTask(with: url, completionHandler: {(data, response, error) in
            if error != nil { completion(nil); return }
            
            guard let data = data else { completion(nil); return }
            
            //need to serialize the data... need do, because serialization requires a try
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], let items = json["items"] as? [[String:Any]] {
                    
                    //need an array to store the incoming users
                    var searchedUsers = [User]()
                    
                    
                    for userJSON in items {
                        if let user = User(json: userJSON) {
                            searchedUsers.append(user)
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation {
                        completion(searchedUsers)
                    }
                    
                }
            } catch {
                print(error)
            }
            
        }).resume()
    }
    
    func searchRepoWith(searchTerm: String, completion: @escaping RepoSearchCompletion) {
        
        //need an array to store the filtered results
        var filteredRepos = [Repository]()
        
        
        for repo in GitHubService.shared.allRepos {
            if repo.name == searchTerm {
                filteredRepos.append(repo)
            }
        }
        
        
        OperationQueue.main.addOperation {
            completion(filteredRepos)
        }
 
    }
    
    //NETWORK CALL:
    func fetchRepos(completion: @escaping RepositoriesCompletion) {
        self.urlComponents.path = "/user/repos"
        guard let url = self.urlComponents.url else {
            completion(nil); return
        }
        
        //That little dangling in is because of the completion syntax. We don't have to put anything after but it has to be there almost as the signature
        
        print(url.absoluteString)
        
        self.session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil { completion(nil); return }
            
            if let data = data {
                
                var repos = [Repository]()
                
                do {
                    print(response)
                    
                    //for json data we always want mutable contaons
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        
                        for repoJSON in json {
                            if let repository = Repository(json: repoJSON) {
                                repos.append(repository)
                            }
                        }
                        
                        //dataTasks are threadsafe so we have to add it back to the main queue
                        OperationQueue.main.addOperation {
                            completion(repos)
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
        }).resume()
    }
    
    
    func oAuthWith(parameters: [String: String]) {
        
        var parameterString = String()
        
        for(key, value) in parameters {
            parameterString += "&\(key)=\(value)"
        }
        
        if let requestURL = URL(string: "\(kBaseUrlString)authorize?client_id=\(kGitHubClientID)\(parameterString)") {
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
        }
        
    }
    
    func codeFrom(url: URL) throws -> String {
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw GitHubOAuthError.extractingCode("Temporary code not found in string. See codeFrom()")
        }
        
        return code
    }
    
    func accessTokenFrom(_ string: String) -> String? {
        if string.contains("access_token"){
            
            //this searches through a string and seperates by &
            let components = string.components(separatedBy: "&")
            
            for component in components {
                if component.contains("access_token") {
                    let token = component.components(separatedBy: "=").last
                    return token
                }
            }
            
        }
        return nil
    }
    
    
    
    func tokenRequestFor(url: URL, options: SaveOptions, completion: @escaping GitHubAuthCompletion) {
        func returnToMainWith(success: Bool) {
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        do {
            let code = try codeFrom(url: url)
            
            //We need to go back to GitHub to get our access token
            let requestString = "\(kBaseUrlString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString) {
                
                let session = URLSession(configuration: .ephemeral)
                
                //Data tasks have to be resumed for whatever reason
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    if error != nil { returnToMainWith(success: false) }
                    
                    //if data doesn't exist, we've already gotten past the error, so we can return to main.
                    guard let data = data else { returnToMainWith(success: true); return }
                    
                    if let dataString = String(data: data, encoding: .utf8) {
                        
                        //if we can get a token out of this string
                        if let token = self.accessTokenFrom(dataString) {
                            print("Access Token: \(token)")
                            
                            //then we're saving it in userDeafaults
                            let success = UserDefaults.standard.save(accessToken: token)
                            
                            print(UserDefaults.standard.getAccessToken()!)
                            
                            returnToMainWith(success: success)
                        }
                    } else {
                        
                        returnToMainWith(success: false)
                    }
                }).resume()
            }
        } catch {
            returnToMainWith(success: false)
        }
    }
    
    
    private init () {
        
        // ephemeral means that its reusuable over and over but the session wont cache everytime.
        self.session = URLSession(configuration: .ephemeral)
        
        self.urlComponents = URLComponents()
        configure()
    }
    
}

