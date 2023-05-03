//
//  RecordRunningCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import UIKit
import CoreLocation
import MapKit

final class RunningCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let locationManager: CLLocationManager = CLLocationManager()
    let locationService: LocationService = LocationService(locationManager: CLLocationManager())
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showStartRunningView()
    }
    
    func showStartRunningView() {
        self.navigationController.isNavigationBarHidden = true
        let runningStartVC = RunningStartViewController(viewModel: RunningStartViewModel(coordinator: self), locationManager: locationManager)
        self.navigationController.pushViewController(runningStartVC, animated: false)
    }
    
    func showRecordRunningView(goalTime: Int, goalDistance: Double) {
        let recordRunningViewController = RecordViewController(viewModel: RecordViewModel(goalTime: goalTime, goalDistance: goalDistance, locationService: locationService))
        recordRunningViewController.modalPresentationStyle = .fullScreen
        navigationController.present(recordRunningViewController, animated: false)
    }
    
    func showRunningMapView(mapView: MKMapView) {
        let runningRecordMapView = RunningRecordMapViewController(mapView: mapView, viewModel: RunningRecordMapViewModel(locationService: locationService))
        runningRecordMapView.modalPresentationStyle = .fullScreen
        navigationController.present(runningRecordMapView, animated: true)
    }
    
    deinit {
        print("deinit recordRunningCoordinator")
    }
    
}
