//
//  RunningRecordRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/30.
//

import CoreData
import RxSwift

final class DefaultRunningRecordRepository {
    
    let runningRecordStroage: RunningRecordStorage
    
    init(runningRecordStroage: RunningRecordStorage) {
        self.runningRecordStroage = runningRecordStroage
    }
}

extension DefaultRunningRecordRepository: RunningRecordRepository {
    
    func deleteRunningRecord(runningDate: Date) throws {
        do {
            try runningRecordStroage.deleteRunningRecord(runningDate: runningDate)
        } catch {
            throw CoreDataStorageError.deleteError(error)
        }
    }
    
    func fetchRunningRecordList() -> Single<RunningRecordList> {
        return runningRecordStroage.fetchRunningRecordList()
    }
    
    func saveRunningRecord(runningRecord: RunningRecord) throws {
        do {
            try runningRecordStroage.saveRunningRecord(runningRecord: runningRecord)
        } catch {
            throw CoreDataStorageError.saveError(error)
        }
    }
}
