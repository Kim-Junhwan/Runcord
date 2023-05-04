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
        let toView = transitionContext.viewController(forKey: .to)!.view!
        guard let fromView = presenting ? toView : transitionContext.view(forKey: .from) else { fatalError() }
        
        let initialFrame = presenting ? originFrame : fromView.frame
        let finalFrame = presenting ? fromView.frame : originFrame

        let yScaleFactor = presenting ?
          initialFrame.height / finalFrame.height :
          finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: 1.0, y: yScaleFactor)

        if presenting {
            fromView.transform = scaleTransform
            fromView.center = CGPoint(
            x: initialFrame.midX,
            y: initialFrame.midY)
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(fromView)
        UIView.animate(withDuration: animationInterval) {
            fromView.transform = self.presenting ? .identity : scaleTransform
            fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        } completion: { _ in
            transitionContext.completeTransition(true)
            if !self.presenting {
                self.dismissCompletion!()
            }
        }
    }
    
}
