//
//  Extensions.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 10/31/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

extension UIResponder {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UserDefaults {

    func getAccessToken() -> String? {
        let accessToken = self.string(forKey: "access_token")
        return accessToken
    }

    func save(accessToken: String) -> Bool {
        self.set(accessToken, forKey: "access_token")
        return synchronize()
    }

    func resetToken() {
        self.set(nil, forKey: "access_token")
    }
}
