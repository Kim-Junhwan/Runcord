//
//  RunningRecordRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/30.
//

import Foundation

protocol RunningRecordRepository {
    func fetchRunningRecordList() throws -> [RunningRecord]
    func fetchRunningRecord() throws -> RunningRecord
    func saveRunningRecord(runningRecord: RunningRecord) throws
}