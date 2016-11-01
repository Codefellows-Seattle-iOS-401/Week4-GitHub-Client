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



enum GitHubOAuthError: Error {
    case extractingCode(String)
}


enum SaveOptions {
    case userDefaults
    
}


class GitHubService {
    
    static let shared = GitHubService()
    
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
    }
    
    
    private init () {
        
    }
    
}

