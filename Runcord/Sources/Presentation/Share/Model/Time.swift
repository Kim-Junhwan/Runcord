//
//  TimeVO.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/21.
//

import Foundation

struct Time {
    private let seconds: Int
    
    func formatedTimeToString(format: TimeFormatType) -> String {
        return format.convertTimeToString(seconds: seconds)
    }
}
