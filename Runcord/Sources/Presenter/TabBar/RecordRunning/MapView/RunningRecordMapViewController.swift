//
//  RunningRecordMapViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/17.
//

import UIKit
import MapKit

class RunningRecordMapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    let closeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.widthAnchor.constraint(equalToConstant: 90).isActive = true
         button.heightAnchor.constraint(equalToConstant: 90).isActive = true
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        
         return button
    }()
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setButton()
    }
    
    private func setButton() {
        closeButton.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
        mapView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.removeConstraints(mapView.constraints)
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func dismissMapView() {
        self.dismiss(animated: false)
    }
    
    deinit {
        print("deinit RunningMapView")
    }
}
