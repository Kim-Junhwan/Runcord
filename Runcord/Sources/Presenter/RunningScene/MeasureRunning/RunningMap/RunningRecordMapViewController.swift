//
//  RunningRecordMapViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/17.
//

import UIKit
import MapKit
import RxSwift

class RunningRecordMapViewController: UIViewController {
    
    var customMapView: CustomMapView!
    
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
    let disposeBag: DisposeBag = DisposeBag()
    
    init(mapView: CustomMapView, viewModel: RunningRecordMapViewModel) {
        self.customMapView = mapView
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
        imageAnnotationBind()
    }
    
    private func imageAnnotationBind() {
        viewModel.imageListDriver.drive(with: self) { owner, imageList in
            owner.customMapView.mapView.removeAnnotations(owner.customMapView.mapView.annotations)
            for image in imageList {
                let annotation = ImageAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(image.latitude, image.longitude)
                annotation.image = image.image
                owner.customMapView.mapView.addAnnotation(annotation)
            }
        }.disposed(by: disposeBag)
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
        customMapView.mapView.isZoomEnabled = true
        customMapView.mapView.isScrollEnabled = true
        customMapView.translatesAutoresizingMaskIntoConstraints = false
        customMapView.removeConstraints(customMapView.constraints)
        customMapView.mapView.register(ImageAnnotationView.self, forAnnotationViewWithReuseIdentifier: ImageAnnotationView.identifier)
        view.addSubview(customMapView)
        NSLayoutConstraint.activate([
            customMapView.topAnchor.constraint(equalTo: view.topAnchor),
            customMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        customMapView.layoutIfNeeded()
    }
    private func removeMapViewGesture() {
        guard let gestures = customMapView.gestureRecognizers else { return }
        for gesture in gestures {
            customMapView.removeGestureRecognizer(gesture)
        }
    }
    
    @objc func dismissMapView() {
        buttonStackView.removeFromSuperview()
        customMapView.mapView.removeAnnotations(customMapView.mapView.annotations)
        self.dismiss(animated: true)
    }
    
    @objc func setUserTracking() {
        customMapView.mapView.setUserTrackingMode(.follow, animated: true)
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

extension RunningRecordMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, let metaData = info[.mediaMetadata] as? NSDictionary {
            viewModel.saveImage(image: image, metaData: metaData)
        }
        picker.dismiss(animated: true)
    }
}