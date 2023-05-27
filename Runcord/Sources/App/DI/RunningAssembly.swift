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
        container.register(LocationService.self) { _ in
            return DefaultLocationService(locationManager: CLLocationManager())
        }.inObjectScope(.container)
        
        container.register(RunningStartViewController.self) { resolver, actions in
            let locationService = resolver.resolve(LocationService.self)!
            return RunningStartViewController(viewModel: RunningStartViewModel(actions: actions), locationService: locationService)
        }
        
        container.register(SaveRecordRunningViewController.self) { resolver, runningRecord in
            let runningRecordRepository = resolver.resolve(RunningRecordRepository.self)!
            return SaveRecordRunningViewController(runningRecord: runningRecord, runningRecordRepository: runningRecordRepository)
        }
        
        container.register(RecordViewModel.self) { resolver, goalTime, goalDistance in
            let locationService = resolver.resolve(LocationService.self)!
            return RecordViewModel(goalTime: goalTime, goalDistance: goalDistance, locationService: locationService)
        }
        
        container.register(RecordViewController.self) { resolver, viewModel in
            return RecordViewController(viewModel: viewModel)
        }
    }
}
