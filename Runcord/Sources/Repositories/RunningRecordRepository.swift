//
//  RunningRecordRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/30.
//

import Foundation
import CoreData
import RxSwift

protocol RunningRecordRepository {
    func fetchRunningRecordList() -> Observable<Result<[RunningRecord], Error>>
    func saveRunningRecord(runningRecord: RunningRecord)
}

final class DefaultRunningRecordRepository {
    
    let coreDataRunningRecordStroage: CoreDataRunningRecordStroage
    
    init(coreDataStorage: CoreDataRunningRecordStroage) {
        self.coreDataRunningRecordStroage = coreDataStorage
    }
}

extension DefaultRunningRecordRepository: RunningRecordRepository {
    func fetchRunningRecordList() -> Observable<Result<[RunningRecord], Error>> {
        return coreDataRunningRecordStroage.fetchRecentRunningRecords()
    }
    
    func saveRunningRecord(runningRecord: RunningRecord) {
        coreDataRunningRecordStroage.saveRunningRecord(runningRecord: runningRecord)
    }
    
}
