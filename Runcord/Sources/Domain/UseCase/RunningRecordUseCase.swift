//
//  RunningRecordUseCase.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/25.
//

import RxSwift

protocol RunningRecordUseCase {
    func fetchRunningRecordList() -> Single<RunningRecordList>
    func saveRunningRecord(runningRecord: RunningRecord) throws
    func deleteRunningRecord(runningDate: Date) throws
}

final class DefaultRunningRecordUseCase: RunningRecordUseCase {
    let repository: RunningRecordRepository
    
    init(repository: RunningRecordRepository) {
        self.repository = repository
    }
    
    func fetchRunningRecordList() -> Single<RunningRecordList> {
        return repository.fetchRunningRecordList()
    }
    
    func saveRunningRecord(runningRecord: RunningRecord) throws {
        do{
            try repository.saveRunningRecord(runningRecord: runningRecord)
        } catch {
            throw CoreDataStorageError.saveError(error)
        }
    }
    
    func deleteRunningRecord(runningDate: Date) throws {
        do {
            try repository.deleteRunningRecord(runningDate: runningDate)
        } catch {
            throw CoreDataStorageError.deleteError(error)
        }
    }
}
