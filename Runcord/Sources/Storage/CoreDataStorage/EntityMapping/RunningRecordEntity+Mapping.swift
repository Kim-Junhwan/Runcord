//
//  RunningRecordEntity+Mapping.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/17.
//

import Foundation
import CoreData
import UIKit

extension RunningRecordEntity {
    
    convenience init(runningRecord: RunningRecord, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        date = runningRecord.date
        goalDistance = runningRecord.goalDistance
        goalTime = Int64(runningRecord.goalTime)
        runningDistance = runningRecord.runningDistance
        runningTime = Int32(runningRecord.runningTime)
        var count = 1
        runningRecord.runningPath.forEach { route in
            addToRunningPath(route.toEntity(orderNum: count, in: context))
            count += 1
        }
    }
    
    func toDomain() -> RunningRecord {
        return .init(date: date ?? Date(),
            goalDistance: goalDistance,
            goalTime: Int(goalTime),
            runningDistance: runningDistance,
            runningTime: Int(runningTime),
                     runningPath: runningPath?.allObjects.map { ($0 as! RunningRouteEntity).toDomain() } ?? [],
            imageRecords: imageList?.allObjects.map { $0 as! ImageInfo } ?? []
        )
    }
}

extension RunningRoute {
    func toEntity(orderNum: Int, in context: NSManagedObjectContext) -> RunningRouteEntity {
        let entity: RunningRouteEntity = .init(context: context)
        entity.orderNum = Int64(orderNum)
        entity.latitude = latitude
        entity.longitude = longitude
        return entity
    }
}

extension RunningRouteEntity {
    func toDomain() -> RunningRoute {
        return .init(longitude: longitude, latitude: latitude)
    }
}

extension ImageInfoEntity {
    func toDomain() -> ImageInfo {
        return .init(latitude: latitude, longitude: longitude, image: UIImage(data: image ?? Data()) ?? UIImage(systemName: "")!, saveTime: date ?? Date())
    }
}
