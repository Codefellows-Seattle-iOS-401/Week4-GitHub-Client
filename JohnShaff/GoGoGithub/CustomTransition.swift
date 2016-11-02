//
//  CustomTransition.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/2/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class CustomTransition: NSObject {
    
    var duration: TimeInterval
    
    //This provides two initializers to the developer
    init(duration: TimeInterval = 1.0) {
        self.duration = duration
    }
}


extension CustomTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        //We're setting our starting alpha at invisible
        toViewController.view.alpha = 0.0
        
        
        UIView.animate(withDuration: duration, animations: {
            
            //We're animating it to appear
            toViewController.view.alpha = 1.0
            
        }, completion: { (finished) in
            transitionContext.completeTransition(true)
        })
        
    }
}
