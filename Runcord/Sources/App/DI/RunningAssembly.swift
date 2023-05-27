//
//  RunningAssembly.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/27.
//

import Swinject
import CoreLocation

struct RunningAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RunningStartViewModel.self) { resolver in
            return RunningStartViewModel()
        }
        
        container.register(RunningStartViewController.self) { resolver in
            let viewModel = resolver.resolve(RunningStartViewModel.self)!
            return RunningStartViewController(viewModel: viewModel, locationManager: CLLocationManager())
        }
        
        container.register(SaveRecordRunningViewController.self) { resolver, runningRecord in
            let runningRecordRepository = resolver.resolve(RunningRecordRepository.self)!
            return SaveRecordRunningViewController(runningRecord: runningRecord, runningRecordRepository: runningRecordRepository)
        }
    }
}
