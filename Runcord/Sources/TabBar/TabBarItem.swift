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
    case recordRunningList
    
    func itemTitleValue() -> String {
        switch self {
        case .recordRunning:
            return "러닝"
        case .recordRunningList:
            return "러닝기록"
        }
    }
    
    func itemImageValue() -> UIImage? {
        switch self {
        case .recordRunning:
            return UIImage(named: "RecordRunning.svg")
        case .recordRunningList:
            return UIImage(named: "MyPage.svg")
        }
    }
    
}
