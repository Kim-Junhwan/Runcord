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
    var locationManager: CLLocationManager
    
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
        mapView.delegate = self
        setButton()
        setGoalView()
        bind()
        setLocationManager()
    }
    
    func setLocationManager() {
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            setMapUserTracking()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    private func bind() {
        viewModel.goalDistance.subscribe { distance in
            guard let distance = distance.element else { return }
            self.goalDistanceLabel.text = "\(distance)"
        }.disposed(by: disposeBag)
        
        viewModel.goalTimeRelay.subscribe { time in
            guard let time = time.element else { return }
            let timeStr = time.split(separator: ":").map { String($0) }
            self.goalHourLabel.text = timeStr[0]
            self.goalMinuteLabel.text = timeStr[1]
        }.disposed(by: disposeBag)
    }
    
    init(viewModel: RunningStartViewModel) {
        self.viewModel = viewModel
        self.locationManager = CLLocationManager()
        super.init(nibName: "RunningStartViewController", bundle: nil)
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
        let vc = makeGoalSettingView(goalType: .distance)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        vc.setGoalHandler = { [weak self] goalStr in
            self?.viewModel.setGoalDistance(goal: goalStr)
        }
        present(nvc, animated: false)
    }
    
    @objc func presentTimeGoalSettingView() {
        let vc = makeGoalSettingView(goalType: .time)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        vc.setGoalHandler = { [weak self] goalStr in
            self?.viewModel.setGoalTime(goal: goalStr)
        }
        present(nvc, animated: false)
    }
    
    private func makeGoalSettingView(goalType: GoalType) -> GoalSettingViewController {
        let vc = GoalSettingViewController(goalType: goalType)
        if vc.goalType == .distance {
            vc.goalLabelBindingTextField.text = "\(viewModel.goalDistance.value)"
            return vc
        } else {
            if viewModel.goalMinute.value == 0 {
                vc.goalLabelBindingTextField.text = "\(viewModel.goalHour.value)00"
            } else {
                vc.goalLabelBindingTextField.text = "\(viewModel.goalHour.value)\(viewModel.goalMinute.value)"
            }
            return vc
        }
    }
    
    deinit {
        print("deinit runningStart view")
    }
    
}

extension RunningStartViewController: MKMapViewDelegate {
    
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
