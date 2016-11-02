//
//  Repository.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/1/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import Foundation


class Repository {
    
    let name: String
    let description: String?
    let language: String?
    
//    let myRepos = Repository(json: GET blah blah blah)
    
    
    //fallible so if for some reason not everything gets initilized it doesn crash its just nil
    init? (json: [String: Any]) {
        
        //using an if let because the api says every repo has a name so we're just using that property as a check
        if let name = json["name"] as? String {
            self.name = name
            self.description = json["description"] as? String
            self.language = json["language"] as? String
        } else {
            return nil
        }
    }
}

