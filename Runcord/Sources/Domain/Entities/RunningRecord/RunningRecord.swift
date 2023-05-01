//
//  RunningRecord.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/30.
//

import Foundation

struct RunningRecord {
    let date: Date
    
    let goalDistance: Double
    let goalTime: Int
    
    let runningDistance: Double
    let runningTime: Int
    
    let runningPath: [(Double, Double)]
    let imageRecords: [ImageInfo]
}