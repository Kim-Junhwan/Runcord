//
//  TabBarItem.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import Foundation
import UIKit

enum TabBarItem: Int {
    private enum TabBarItemTitle {
        static let recordRunning: String = "러닝"
        static let recordRunningList: String = "러닝기록"
    }
    
    private enum TabBarItemImage {
        static let recordRunning: String = "RecordRunning.svg"
        static let recordRunningList: String = "MyPage.svg"
    }
    
    case recordRunning = 0
    case recordRunningList
    
    func itemTitleValue() -> String {
        switch self {
        case .recordRunning:
            return TabBarItemTitle.recordRunning
        case .recordRunningList:
            return TabBarItemTitle.recordRunningList
        }
    }
    
    func itemImageValue() -> UIImage? {
        switch self {
        case .recordRunning:
            return UIImage(named: TabBarItemImage.recordRunning)
        case .recordRunningList:
            return UIImage(named: TabBarItemImage.recordRunningList)
        }
    }
    
}
