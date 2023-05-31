//
//  LongPressGestureButton.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/29.
//

import UIKit

protocol PressGestureButtonDelegate {
    func animationComplete()
}

class LongPressGestureButton: UIButton, CAAnimationDelegate {
    
    var delegate: PressGestureButtonDelegate?
    
    let sliceLayer = CAShapeLayer()
    var duringGestureTime: Int?
    var startEngle: CGFloat = .pi * (3/2)
    var endAngle: CGFloat = .pi * (7/2)
    
    init(gestureTime: Int) {
        self.duringGestureTime = gestureTime
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
        addTarget(self, action: #selector(startAnimation), for: .touchDown)
    }
    
    @objc func startAnimation() {
        
        let path = UIBezierPath(arcCenter: center, radius: frame.width/2+2, startAngle: startEngle, endAngle: endAngle, clockwise: true)
        sliceLayer.path = path.cgPath
        sliceLayer.fillColor = nil
        sliceLayer.strokeColor = UIColor.black.cgColor
        sliceLayer.lineWidth = 4
        sliceLayer.strokeEnd = 0
        layer.addSublayer(sliceLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.fillMode = .forwards
        sliceLayer.add(animation, forKey: animation.keyPath)
    }
    
    @objc func stopAnimation() {
        sliceLayer.removeAllAnimations()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.delegate?.animationComplete()
        }
    }
}
