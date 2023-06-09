//
//  CoreDataRunningRecordStroage.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/17.
//

import RxSwift

protocol RunningRecordStorage {
    func fetchRunningRecordList() -> Single<RunningRecordList>
    func saveRunningRecord(runningRecord: RunningRecord) throws
    func deleteRunningRecord(runningDate: Date) throws
}
