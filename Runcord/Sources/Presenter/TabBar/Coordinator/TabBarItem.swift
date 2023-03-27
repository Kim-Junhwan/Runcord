//
//  TabBarItem.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import Foundation
import UIKit

enum TabBarItem: Int {
    case recordRunning = 0
    case myPage
    
    func itemTitleValue() -> String {
        switch self {
        case .recordRunning:
            return "러닝"
        case .myPage:
            return "마이페이지"
        }
    }
    
    func itemImageValue() -> UIImage? {
        switch self {
        case .recordRunning:
            return UIImage(named: "RecordRunning.svg")
        case .myPage:
            return UIImage(named: "MyPage.svg")
        }
    }
    
}
