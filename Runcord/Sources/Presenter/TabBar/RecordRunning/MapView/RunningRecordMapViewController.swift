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
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 40
        return stackView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 44.0), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }()
    
    let userTrackingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 44.0), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
        button.setImage(UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.setPreferredSymbolConfiguration(.init(pointSize: 44.0), forImageIn: .normal)
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
        setButtonAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setButtonStackView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setButtonLayout()
    }
    
    private func setButtonStackView() {
        buttonStackView.addArrangedSubview(userTrackingButton)
        buttonStackView.addArrangedSubview(cameraButton)
        buttonStackView.addArrangedSubview(closeButton)
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
    
    private func setButtonAction() {
        userTrackingButton.addTarget(self, action: #selector(setUserTracking), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
    }
    
    private func setButtonLayout() {
        buttonStackView.layoutIfNeeded()
        userTrackingButton.layer.cornerRadius = userTrackingButton.frame.height/2
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        cameraButton.layer.cornerRadius = cameraButton.frame.height/2
    }
    
    private func setMapView() {
        removeMapViewGesture()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.removeConstraints(mapView.constraints)
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        mapView.layoutIfNeeded()
    }
    private func removeMapViewGesture() {
        guard let gestures = mapView.gestureRecognizers else { return }
        for i in gestures {
            mapView.removeGestureRecognizer(i)
        }
    }
    
    @objc func dismissMapView() {
        buttonStackView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    @objc func setUserTracking() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    deinit {
        print("deinit RunningMapView")
    }
}

extension RunningRecordMapViewController: MKMapViewDelegate {
    
}
