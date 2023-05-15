//
//  RunningRecordRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/30.
//

import Foundation
import CoreData

protocol RunningRecordRepository {
    func fetchRunningRecordList() throws -> [RunningRecord]
    func fetchRunningRecord() throws -> RunningRecord
    func saveRunningRecord(runningRecord: RunningRecord) throws
}

final class DefaultRunningRecordRepository: RunningRecordRepository {
    
    lazy var runningRecordContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecordRunningDataBase")
        container.loadPersistentStores { _, error in
            guard error == nil else { fatalError("Cannot load DataBases. \(error?.localizedDescription)") }
        }
        return container
    }()
    
    func fetchRunningRecordList() throws -> [RunningRecord] {
        return []
    }
    
    func fetchRunningRecord() throws -> RunningRecord {
        return RunningRecord(date: Date(), goalDistance: 0, goalTime: 0, runningDistance: 0, runningTime: 0, runningPath: [], imageRecords: [])
    }
    
    func saveRunningRecord(runningRecord: RunningRecord) throws {
        
    }
    
}
