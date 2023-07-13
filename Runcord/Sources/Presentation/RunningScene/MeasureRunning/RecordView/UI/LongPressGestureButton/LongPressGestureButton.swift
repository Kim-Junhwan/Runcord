//
//  LongPressGestureButton.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/29.
//

import UIKit

protocol PressGestureButtonDelegate: AnyObject {
    func animationComplete()
}

class LongPressGestureButton: UIButton, CAAnimationDelegate {
    
    private enum GestureMetric {
        static let startEngle: CGFloat = .pi * (3/2)
        static let endEngle:CGFloat = .pi * (7/2)
        static let lineWidth: CGFloat = 4.0
        static let strokeEnd: CGFloat = 0.0
        static let radiusOffset: CGFloat = 2.0
    }
    
    private enum AnimationMetric {
        static let start: Float = 0.0
        static let end: Float = 1.0
    }
    
    weak var delegate: PressGestureButtonDelegate?
    
    let sliceLayer = CAShapeLayer()
    var duringGestureTime: Double?
    var startEngle: CGFloat = GestureMetric.startEngle
    var endAngle: CGFloat = GestureMetric.endEngle
    
    init(gestureTime: Double) {
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
        let path = UIBezierPath(arcCenter: centerCoordi, radius: frame.width/2+GestureMetric.radiusOffset, startAngle: startEngle, endAngle: endAngle, clockwise: true)
        sliceLayer.path = path.cgPath
        sliceLayer.fillColor = nil
        sliceLayer.strokeColor = UIColor.black.cgColor
        sliceLayer.lineWidth = GestureMetric.lineWidth
        sliceLayer.strokeEnd = GestureMetric.strokeEnd
        layer.addSublayer(sliceLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = AnimationMetric.start
        animation.toValue = AnimationMetric.end
        animation.duration = CFTimeInterval(duringGestureTime ?? 0)
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
