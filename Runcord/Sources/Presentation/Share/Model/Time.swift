//
//  TimeVO.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/21.
//

import Foundation

struct Time {
    
    private let seconds: Int
    
    var hour: Int {
        get {
            return seconds / 3600
        }
    }
    
    var minute: Int {
        get {
            return (seconds % 3600) / 60
        }
    }
    
    var second: Int {
        get {
            return seconds % 60
        }
    }
    
    init(seconds: Int = 0, minute: Int = 0, hour: Int = 0) {
        let totalSeconds = seconds + (60*minute) + (3600*hour)
        self.seconds = totalSeconds
    }
    
    func formatedTimeToString(format: TimeFormatType) -> String {
        return format.convertTimeToString(seconds: seconds)
    }
}
