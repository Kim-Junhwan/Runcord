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

class RunningStartViewController: UIViewController, Alertable {
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var goalDistanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    private func setMapView() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setButton() {
        startButton.cornerRadius = startButton.frame.height/2
    }
    
    deinit {
        print("deinit runningStart view")
    }
    
}
