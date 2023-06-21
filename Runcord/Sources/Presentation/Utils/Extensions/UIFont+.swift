//
//  UIFont+.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/12.
//

import UIKit

extension UIFont {
    static func boldNotoSansFont(ofSize: Double) -> UIFont {
        guard let bolsNotoSansFont = UIFont(name: "NotoSansKR-Bold", size: ofSize) else { return UIFont.systemFont(ofSize: ofSize) }
        return bolsNotoSansFont
    }
    
    static func mediumNotoSansFont(ofSize: Double) -> UIFont {
        guard let mediumNotoSansFont = UIFont(name: "NotoSansKR-Medium", size: ofSize) else { return UIFont.systemFont(ofSize: ofSize) }
        return mediumNotoSansFont
    }
}
