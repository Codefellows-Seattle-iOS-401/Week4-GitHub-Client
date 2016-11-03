//
//  User.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/3/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import Foundation

class User {
    
    let login: String
    let webUrl: String
    let avatarUrl: String?
    
    //The question mark is making this a fallible initializer. Meaning if we EVER return something from within the init block, the initializer will not instantiate it will just return. 
    init?(json: [String: Any]) {
        if let login = json["login"] as? String, let webUrl = json["html_url"] as? String {
            self.login = login
            self.webUrl = webUrl
            self.avatarUrl = json["avatar_url"] as? String
        } else {
            return nil
        }
    }
    
}
