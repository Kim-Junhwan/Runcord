//
//  RunningRecordListAssembly.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/27.
//

import Swinject

struct RunningRecordListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RunningRecordListViewModel.self) { resolver, actions in
            let runningRecordUseCase = resolver.resolve(RunningRecordUseCase.self)!
            return RunningRecordListViewModel(runningRecordUseCase: runningRecordUseCase, actions: actions)
        }
        
        container.register(RunningRecordListViewController.self) { resolver, actions in
            let runningRecordUseCase = resolver.resolve(RunningRecordUseCase.self)!
            return RunningRecordListViewController(viewModel: RunningRecordListViewModel(runningRecordUseCase: runningRecordUseCase, actions: actions))
        }
    }
}
