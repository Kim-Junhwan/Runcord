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
    
    let viewModel: RunningRecordMapViewModel
    
    init(mapView: MKMapView, viewModel: RunningRecordMapViewModel) {
        self.mapView = mapView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setButtonAction()
        imageBing()
    }
    
    private func imageBing() {
        viewModel.imageListDriver.drive(with: self) { owner, imageList in
            guard let currentImage = imageList.last else { return }
            let annotation = ImageAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(currentImage.latitude, currentImage.longitude)
            annotation.image = currentImage.image
            owner.mapView.addAnnotation(annotation)
        }
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
        cameraButton.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
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
        mapView.register(ImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: ImageAnnotationView.identifier)
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
        for gesture in gestures {
            mapView.removeGestureRecognizer(gesture)
        }
    }
    
    @objc func dismissMapView() {
        buttonStackView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    @objc func setUserTracking() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func takePicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    deinit {
        print("deinit RunningMapView")
    }
}

extension RunningRecordMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: ImageAnnotationView.identifier) as? ImageAnnotationView
        
        if annotationView == nil {
            annotationView = ImageAnnotationView(annotation: annotation, reuseIdentifier: ImageAnnotationView.identifier)
        }
        guard let imageAnnotation = annotation as? ImageAnnotation else { return nil}
        annotationView?.image = imageAnnotation.image
        annotationView?.annotation  = imageAnnotation
        annotationView?.centerOffset = CGPointMake(0, -(annotationView?.frame.size.height)!/2)
        return annotationView
    }
}

extension RunningRecordMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, let metaData = info[.mediaMetadata] as? NSDictionary {
            viewModel.saveImage(image: image, metaData: metaData)
        }
        picker.dismiss(animated: true)
    }
}
