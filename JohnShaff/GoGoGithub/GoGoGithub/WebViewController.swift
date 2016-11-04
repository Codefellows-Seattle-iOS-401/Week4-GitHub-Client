//
//  WebViewController.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/3/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var webURL: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this makes it the size of the view frame
        webView.frame = self.view.frame
        
        //this makes the webview a subview of the view
        self.view.addSubview(webView)
        
        //Get the string and turn into a url
        if let url = URL(string: webURL) {
            //then I'm turning it into a request because the load method request it to be of URLRequest type
            let request = URLRequest(url: url)
            
            //All of that above was to format this request constant into the parameter the load method needs
            self.webView.load(request)
        }
    }


}
