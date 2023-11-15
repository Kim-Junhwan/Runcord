//
//  RunningAssembly.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/27.
//

import Swinject
import CoreLocation
import CoreMotion

struct RunningAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocationService.self) { _ in
            return DefaultLocationService(locationManager: CLLocationManager())
        }.inObjectScope(.container)
        
        container.register(MotionService.self) { _ in
            return CMMotionActivityManagerMotionService()
        }.inObjectScope(.container)
        
        container.register(RunningStartViewController.self) { resolver, actions in
            let locationService = resolver.resolve(LocationService.self)!
            let activityManager = resolver.resolve(MotionService.self)!
            return RunningStartViewController(viewModel: RunningStartViewModel(actions: actions), locationService: locationService, activityManager: activityManager)
        }
        
        container.register(SaveRecordRunningViewController.self) { resolver, runningRecord in
            let runningRecordRepository = resolver.resolve(RunningRecordRepository.self)!
            return SaveRecordRunningViewController(runningRecord: runningRecord, runningRecordRepository: runningRecordRepository)
        }
        
        container.register(RecordViewModel.self) { resolver, goalTime, goalDistance, actions in
            let locationService = resolver.resolve(LocationService.self)!
            return RecordViewModel(goalTime: goalTime, goalDistance: goalDistance, locationService: locationService, actions: actions)
        }
        
        container.register(RecordViewController.self) { resolver, viewModel in
            return RecordViewController(viewModel: viewModel)
        }
    }
}
