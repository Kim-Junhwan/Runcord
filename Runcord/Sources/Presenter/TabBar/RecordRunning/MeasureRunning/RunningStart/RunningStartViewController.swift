//
//  RunningStartViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class RunningStartViewController: UIViewController, UsingLocationable {
    
    var locationRepository: LocationRepository
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var goalDistanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setMapView()
        locationRepository.requestAuthorization()
        locationRepository.delegate = self
    }
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
        super.init(nibName: "RunningStartViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: false)
    }
    
    func setButton() {
        startButton.cornerRadius = startButton.frame.height/2
    }
    
    @IBAction func tabStartButton(_ sender: Any) {
        checkLocationAuthorization {
            let vc = RecordViewController(viewModel: RecordViewModel())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    deinit {
        print("deinit runningStart view")
    }
    
}

extension RunningStartViewController: LocationRepositoryDelegate {
    
    func getCurrentLocation(latitude: Double, longitude: Double) {
        print(latitude)
        print(longitude)
    }
}

extension RunningStartViewController: MKMapViewDelegate {
    
}
