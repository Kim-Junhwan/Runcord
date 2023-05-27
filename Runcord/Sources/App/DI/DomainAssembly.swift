//
//  DomainAssembly.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/27.
//

import Swinject

struct DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RunningRecordUseCase.self) { resolver in
            let repository = resolver.resolve(RunningRecordRepository.self)!
            return DefaultRunningRecordUseCase(repository: repository)
        }
    }
}
