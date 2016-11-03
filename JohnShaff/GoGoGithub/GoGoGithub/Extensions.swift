//
//  Extensions.swift
//  GoGoGithub
//
//  Created by John Shaff on 10/31/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

extension String {
    var isValid: Bool {
        let regexPattern = "[^0-9a-z]"
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            
            //the matches pattern requires an NSRange type
            let range = NSRange(location: 0, length: self.characters.count)
            
            let matches = regex.numberOfMatches(in: self, options: .reportCompletion, range: range)
            
        } catch {
            return false
        }
        return true
    }
    
    
}

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
