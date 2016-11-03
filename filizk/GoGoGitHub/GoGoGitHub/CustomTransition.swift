//
//  CustomTransition.swift
//  GoGoGitHub
//
//  Created by Filiz Kurban on 11/2/16.
//  Copyright © 2016 Filiz Kurban. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var duration:TimeInterval

    init(duration: TimeInterval = 1.0) {
        self.duration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {return}

        //transitionContext knows about from and need to know about the view for its containerView to apply animation
        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.alpha = 0.0

        //need the completion handler to tell the caller that we're done with animation
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1.0
            }) { (finished) in
                transitionContext.completeTransition(true)
        }
    }
}
