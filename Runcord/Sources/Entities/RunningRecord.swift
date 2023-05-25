//
//  RunningRecord.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/30.
//

import Foundation
import UIKit

public struct RunningRecordList {
    public let list: [RunningRecord]
}

public struct RunningRecord {
    let date: Date
    let goalDistance: Double
    let goalTime: Int
    let runningDistance: Double
    let runningTime: Int
    let averageSpeed: Double
    let runningPath: [RunningRoute]
    let imageRecords: [ImageInfo]
}

public struct RunningRoute {
    let longitude: Double
    let latitude: Double
}

public struct ImageInfo {
    let latitude: Double
    let longitude: Double
    let image: UIImage
    let saveTime: Date
}
