//
//  MapAnimator.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/16.
//

import UIKit

class MapAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationInterval = 0.2
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { fatalError() }
        guard let recordView = presenting ? toView : transitionContext.view(forKey: .from) else { fatalError() }
        
        let initialFrame = presenting ? originFrame : recordView.frame
        let finalFrame = presenting ? recordView.frame : originFrame

        let yScaleFactor = presenting ?
          initialFrame.height / finalFrame.height :
          finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: 1.0, y: yScaleFactor)

        if presenting {
            recordView.transform = scaleTransform
            recordView.center = CGPoint(
            x: initialFrame.midX,
            y: initialFrame.midY)
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(recordView)
        UIView.animate(withDuration: animationInterval) {
            recordView.transform = self.presenting ? .identity : scaleTransform
            recordView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        } completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }
    
}
