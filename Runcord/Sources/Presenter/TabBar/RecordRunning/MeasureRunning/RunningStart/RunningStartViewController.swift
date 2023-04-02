//
//  RunningStartViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import UIKit
import MapKit

class RunningStartViewController: UIViewController, LocationAlertable {
    var locationManager: CoreLocationManager
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var goalDistanceStackView: UIStackView!
    @IBOutlet weak var goalTimeStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.locationManager.delegate = self
        locationManager.viewDidLoad()
        setButton()
        setGoalView()
    }
    
    init(locationManager: CoreLocationManager) {
        self.locationManager = locationManager
        super.init(nibName: "RunningStartViewController", bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMapView() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: false)
    }
    
    func setButton() {
        startButton.cornerRadius = startButton.frame.height/2
    }
    
    @IBAction func tabStartButton(_ sender: Any) {
        checkLocationAuthorization {
            print("원하는 작업")
        }
    }
    
    func setGoalView() {
        goalDistanceStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentGoalSettingView)))
    }
    
    @objc func presentGoalSettingView() {
        let vc = GoalSettingViewController(goalType: .distance)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: false)
    }
    
    deinit {
        print("deinit runningStart view")
    }
    
}

extension RunningStartViewController: CoreLocationManagerDelegate {
    
    func didChangeAuthorization(status: AuthorizationStatus) {
        if status == .hasAuthorization {
            setMapView()
        }
    }
    
    func getCurrentLocation(latitude: Double, longitude: Double) {
        print("GET COORDINATOR")
        print(latitude)
        print(longitude)
    }
    
}

extension RunningStartViewController: MKMapViewDelegate {
    
}
