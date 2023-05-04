//
//  ArrowView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/05.
//

import UIKit

class ArrowView: UIView {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint(x: self.frame.width * (1/4), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width * (3/4), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width/2, y: self.frame.height))
        path.close()
        UIColor.systemBackground.set()
        path.fill()
    }
}
