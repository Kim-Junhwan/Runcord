//
//  RunningRecordRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/25.
//

import RxSwift

protocol RunningRecordRepository {
    func fetchRunningRecordList() -> Single<RunningRecordList>
    func saveRunningRecord(runningRecord: RunningRecord) throws
    func deleteRunningRecord(runningDate: Date) throws
}
