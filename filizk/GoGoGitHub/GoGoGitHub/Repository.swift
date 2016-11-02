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

    //fallable initializer
    init?(json: [String: Any]) {
        if let name = json["name"] as? String {
            self.name = name
            self.description = json["description"] as? String
            self.language = json["language"] as? String
        } else {
            return nil
        }
    }
}
