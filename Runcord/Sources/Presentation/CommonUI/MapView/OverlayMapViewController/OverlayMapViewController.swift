//
//  OverlayMapViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/22.
//

import CoreLocation
import UIKit

class OverlayMapViewController: UIViewController {
    
    private enum ButtonMetric {
        static let buttonSize: CGFloat = 90.0
        static let buttonSymbolSize: CGFloat = 44.0
        static let buttonBottom: CGFloat = -60.0
    }
    
    let customMapView: CustomMapView = {
       let customMapView = CustomMapView()
        return customMapView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: ButtonMetric.buttonSize).isActive = true
        button.heightAnchor.constraint(equalToConstant: ButtonMetric.buttonSize).isActive = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: ButtonMetric.buttonSymbolSize), forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(dismissMapView), for: .touchUpInside)
        return button
    }()
    
    let runningRecord: RunningRecord
    
    init(runningRecord: RunningRecord) {
        self.runningRecord = runningRecord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customMapView)
        customMapView.frame = view.bounds
        drawOverlay()
        setButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.layer.cornerRadius = closeButton.frame.height/2
    }
    
    @objc func dismissMapView() {
        self.dismiss(animated: true)
    }
    
    private func setButton() {
        customMapView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: ButtonMetric.buttonBottom)
        ])
    }
    
    private func drawOverlay() {
        drawRoute()
        addImageOverlay()
    }
    
    private func drawRoute() {
        let routeCoordinate = runningRecord.runningPath.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
        customMapView.setMapRouteRegion(route: routeCoordinate)
        customMapView.drawRoute(routeList: routeCoordinate)
    }
    
    private func addImageOverlay() {
        runningRecord.imageRecords.forEach { imageInfo in
            let annotation = ImageAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: imageInfo.latitude, longitude: imageInfo.longitude)
            annotation.image = imageInfo.image
            customMapView.appendImageAnnotation(imageAnnotation: annotation)
        }
    }

}
