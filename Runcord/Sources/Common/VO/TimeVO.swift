//
//  TimeVO.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/21.
//

import Foundation

struct TimeVO {
    private let seconds: Int
    
    var formattedTime: String {
        get {
            return TimeFormat.hourMinuteSecond.convertTimeToString(seconds: seconds)
        }
    }
}
