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
        button.setImage(UIImage(systemName: "xmark")?.resizeImageTo(size: CGSize(width: 44.0, height: 44.0)), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        return button
    }()

    let userTrackingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
        button.setImage(UIImage(systemName: "location.circle.fill")?.resizeImageTo(size: CGSize(width: 44.0, height: 44.0)), for: .normal)
        button.tintColor = .white
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
        userTrackingButton.addTarget(self, action: #selector(setUserTracking), for: .touchUpInside)
        mapView.addSubview(userTrackingButton)
        NSLayoutConstraint.activate([
            userTrackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userTrackingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        userTrackingButton.layer.cornerRadius = userTrackingButton.frame.height/2
        
        closeButton.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
        mapView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        closeButton.layer.cornerRadius = closeButton.frame.height/2
    }
    
    private func setMapView() {
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
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
        closeButton.removeFromSuperview()
        userTrackingButton.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    @objc func setUserTracking() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    deinit {
        print("deinit RunningMapView")
    }
}
