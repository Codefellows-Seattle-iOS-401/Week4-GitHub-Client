//
//  Extensions.swift
//  GoGoGithub
//
//  Created by John Shaff on 10/31/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

extension UIResponder {
    
    //This creates a property on all new classes that inherit from UIResponder, that is essentially just a constant that stores the name of the class itself. 
    
    static var identifier: String {
        return String(describing: self)
    }
    
}


//UserDefaults is a persistent dictionary

extension UserDefaults {
    
    
    func getAccessToken() -> String? {
        let accessToken = self.string(forKey: "access_token")
        return accessToken
    }
    
    
    func save(accessToken: String) -> Bool {
        self.set(accessToken, forKey: "access_token")
        return synchronize()
    }
    
}
