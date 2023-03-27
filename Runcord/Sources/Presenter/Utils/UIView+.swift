//
//  UIView+.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/10.
//

import UIKit

extension UIView {
    func setCorderRadius(cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
