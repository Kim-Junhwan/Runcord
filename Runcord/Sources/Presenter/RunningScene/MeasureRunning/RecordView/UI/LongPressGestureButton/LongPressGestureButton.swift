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
        addTarget(self, action: #selector(stopAnimation), for: .touchUpOutside)
    }
    
    @objc func startAnimation() {
        let centerCoordi = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let path = UIBezierPath(arcCenter: centerCoordi, radius: frame.width/2+2, startAngle: startEngle, endAngle: endAngle, clockwise: true)
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
        animation.delegate = self
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
