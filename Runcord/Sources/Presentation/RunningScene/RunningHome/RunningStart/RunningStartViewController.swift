//
//  RunningStartViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import UIKit
import MapKit
import RxSwift

class RunningStartViewController: UIViewController, LocationAlertable {
    var locationService: LocationService
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var goalDistanceStackView: UIStackView!
    @IBOutlet weak var goalTimeStackView: UIStackView!
    @IBOutlet weak var goalHourLabel: UILabel!
    @IBOutlet weak var goalMinuteLabel: UILabel!
    @IBOutlet weak var goalDistanceLabel: UILabel!
    
    let viewModel: RunningStartViewModel
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setGoalView()
        bind()
        setLocationManager()
    }
    
    func setLocationManager() {
        switch locationService.getAuthorizationStatus() {
        case .hasAuthorization:
            setMapUserTracking()
        case .notYet:
            locationService.requestAuthorization()
        default:
            break
        }
    }
    
    private func bind() {
        viewModel.goalDistance.subscribe { distance in
            guard let distance = distance.element else { return }
            self.goalDistanceLabel.text = distance.formattedDistanceToString(type: .defaultFormat)
        }.disposed(by: disposeBag)
        
        viewModel.goalTime.subscribe { time in
            guard let time = time.element else { return }
            self.goalHourLabel.text = String(format: "%02d", time.hour)
            self.goalMinuteLabel.text = String(format: "%02d", time.minute)
        }.disposed(by: disposeBag)
    }
    
    init(viewModel: RunningStartViewModel, locationService: LocationService) {
        self.viewModel = viewModel
        self.locationService = locationService
        super.init(nibName: String(describing: RunningStartViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMapUserTracking() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: false)
    }
    
    private func setMapUserUnTracking() {
        mapView.showsUserLocation = false
        mapView.setUserTrackingMode(.none, animated: false)
    }
    
    func setButton() {
        startButton.cornerRadius = startButton.frame.height/2
    }
    
    @IBAction func tabStartButton(_ sender: Any) {
        checkLocationAuthorization {
            viewModel.presentRecordView()
        }
    }
    
    func setGoalView() {
        goalDistanceStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentDistanceGoalSettingView)))
        goalTimeStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentTimeGoalSettingView)))
    }
    
    @objc func presentDistanceGoalSettingView() {
        let vc = GoalDistanceSettingViewController()
        let nvc = UINavigationController(rootViewController: vc)
        vc.goalLabelBindingTextField.text = viewModel.goalDistanceValue
        nvc.modalPresentationStyle = .fullScreen
        vc.setGoalDistance = { distance in
            self.viewModel.setGoalDistance(distance: distance)
        }
        present(nvc, animated: false)
    }
    
    @objc func presentTimeGoalSettingView() {
        let vc = GoalTimeSettingViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        vc.goalLabelBindingTextField.text = viewModel.goalTimeValue
        vc.setGoalTime = { time in
            self.viewModel.setGoalTime(time: time)
        }
        present(nvc, animated: false)
    }
    
    deinit {
        print("deinit runningStart view")
    }
    
}

extension RunningStartViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            setMapUserTracking()
        case .restricted, .denied:
            setMapUserUnTracking()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
