//
//  Repository.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 11/1/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import Foundation

class Repository {

    let name: String
    let description: String?
    let language: String?
    let createdAt: String?
    let openIssues: Bool?

    //fallable initializer
    init?(json: [String: Any]) {
        if let name = json["name"] as? String {
            self.name = name
            self.description = json["description"] as? String
            self.language = json["language"] as? String
            self.createdAt = json["created_at"] as? String
            self.openIssues = json["open_isses"] as? Bool
        } else {
            return nil
        }
    }
}
