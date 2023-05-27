//
//  DataAssembly.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/27.
//

import Swinject

struct DataAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RunningRecordStorage.self) { _ in
            return CoreDataRunningRecordStroage()
        }
        
        container.register(RunningRecordRepository.self) { resolver in
            let runningRecordStorage = resolver.resolve(RunningRecordStorage.self)!
            return DefaultRunningRecordRepository(runningRecordStroage: runningRecordStorage)
        }
    }
}
