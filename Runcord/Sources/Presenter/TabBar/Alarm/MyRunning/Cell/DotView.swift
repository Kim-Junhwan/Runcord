//
//  DotView.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/19.
//

import UIKit

class DotView: UIView {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let pattern: [CGFloat] = [2.5, 2.5]
        path.move(to: CGPoint(x: 0, y: frame.midY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.midY))
        path.lineWidth = 2
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        
        guard let borderColor = UIColor.tabBarBorder else { return }
        borderColor.set()
        path.stroke()
    }

}
