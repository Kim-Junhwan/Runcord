//
//  SaveRunningRecordUseCase.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/01.
//

import Foundation

protocol SaveRunningRecordUseCase {
    func excute(runningRecord: RunningRecord)
}

final class DefaultSaveRunningRecordUseCase: SaveRunningRecordUseCase {
    
    let repository: RunningRecordRepository
    
    init(repository: RunningRecordRepository) {
        self.repository = repository
    }
    
    func excute(runningRecord: RunningRecord) {
        do {
            try repository.saveRunningRecord(runningRecord: runningRecord)
        } catch {
        }
    }
    
}
