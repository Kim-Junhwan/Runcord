//
//  RecordViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/01.
//

import UIKit
import RxSwift
import CoreLocation
import MapKit

class RecordViewController: UIViewController {
    
    private let recordRunningView: RecordRunningView = {
        let recordRunningView = RecordRunningView()
        recordRunningView.translatesAutoresizingMaskIntoConstraints = false
        return recordRunningView
    }()
    
    private let readyView: ReadyView = {
        let readyView = ReadyView(readyTime: 5)
        readyView.translatesAutoresizingMaskIntoConstraints = false
        return readyView
    }()
    
    private let runningMapView: CustomMapView = {
        let customMapView = CustomMapView()
        customMapView.translatesAutoresizingMaskIntoConstraints = false
        return customMapView
    }()
    
    private lazy var runningMapViewHeightConstraint = runningMapView.heightAnchor.constraint(equalToConstant: 0)
    
    // MARK: - Properties
    var viewModel: RecordViewModel
    let disposeBag = DisposeBag()
    let transition = MapAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRecordRunningView()
        setMapView()
        bind()
        setMapViewDismissCompletion()
        setReadyViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readyView.startPrepare(completion: startMeasureRunning)
    }
    
    func startMeasureRunning() {
        self.readyView.removeFromSuperview()
        self.recordRunningView.isHidden = false
        self.viewModel.startTimer()
        self.viewModel.startTrackUserLocation()
    }
    
    // MARK: - Initalizer
    init(viewModel: RecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RecordViewController", bundle: Bundle(for: RecordViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRecordRunningView() {
        view.addSubview(recordRunningView)
        recordRunningView.isHidden = true
        NSLayoutConstraint.activate([
            recordRunningView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordRunningView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordRunningView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordRunningView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        recordRunningView.setGoalTimeProgressBar(maxValue: Double(viewModel.goalTime))
        recordRunningView.completeButton.delegate = self
        recordRunningView.setGoalDistanceProgressBar(maxValue: viewModel.goalDistance)
        recordRunningView.pauseAndPlayButton.addTarget(self, action: #selector(playOrPauseButtonAction), for: .touchUpInside)
    }
    
    // MARK: - Set MapView
    private func setMapView() {
        setMapViewTabGesture()
        runningMapView.mapView.isScrollEnabled = false
        runningMapView.mapView.isZoomEnabled = false
        runningMapView.mapView.setUserTrackingMode(.follow, animated: true)
        view.addSubview(runningMapView)
        NSLayoutConstraint.activate([
            runningMapView.topAnchor.constraint(equalTo: view.topAnchor),
            runningMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            runningMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            runningMapViewHeightConstraint
        ])
    }
    
    private func setMapViewTabGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentMapView))
        runningMapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentMapView() {
        let runningRecordMapView = RunningRecordMapViewController(mapView: runningMapView, viewModel: RunningRecordMapViewModel(locationService: viewModel.locationService))
        runningRecordMapView.viewModel.imageList.accept(viewModel.imageList)
        runningRecordMapView.viewModel.imageListDriver.drive(with: self) { owner, imageInfoList in
            owner.viewModel.imageList = imageInfoList
        }.disposed(by: disposeBag)
        runningRecordMapView.transitioningDelegate = self
        runningRecordMapView.modalPresentationStyle = .fullScreen
        self.present(runningRecordMapView, animated: true)
    }
    
    func setMapViewDismissCompletion() {
        transition.dismissCompletion = { [weak self] in
            guard let self = self else { return }
            self.runningMapView.removeConstraints(runningMapView.constraints)
            self.runningMapView.mapView.isScrollEnabled = false
            self.runningMapView.mapView.isZoomEnabled = false
            self.view.addSubview(runningMapView)
            NSLayoutConstraint.activate([
                runningMapView.topAnchor.constraint(equalTo: view.topAnchor),
                runningMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                runningMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                runningMapViewHeightConstraint
            ])
            runningMapViewHeightConstraint.constant = view.frame.height * 0.3
            setMapViewTabGesture()
        }
    }
    
    func setReadyViewLayout() {
        view.addSubview(readyView)
        NSLayoutConstraint.activate([
            readyView.topAnchor.constraint(equalTo: view.topAnchor),
            readyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            readyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            readyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Set UI Constraint
    private func hiddenTimerLabel() {
        readyView.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - bind
    private func bind() {
        viewModel.timerText.asDriver()
            .drive(recordRunningView.runningTimerLabel.rx
                .text)
            .disposed(by: disposeBag)

        viewModel.totalRunningSecond.subscribe { currentTime in
            self.recordRunningView.goalTimeProgressView.setCurrentValue(current: Double(currentTime))
        }
        .disposed(by: disposeBag)

        viewModel.runningDistance.asDriver()
            .drive(onNext: { distance in
                self.recordRunningView.runningDistanceLabel.text = String(format: "%.2f", distance)
                self.recordRunningView.goalDistanceProgressView.setCurrentValue(current: Double(distance))
            })
            .disposed(by: disposeBag)

        viewModel.routeDriver.drive(onNext: { route in
            if let lastCoordinate = route.first, let currentCoordinate = route.last {
                self.runningMapView.mapView.updateUserRoute(lastCoordinate: lastCoordinate, newCoordinate: currentCoordinate)
            }
        }).disposed(by: disposeBag)

        viewModel.averageSpeedDriver
            .map({ String(format: "%.2f", $0) })
            .drive(recordRunningView.averageSpeedLabel.rx.text).disposed(by: disposeBag)
    }
    
    // MARK: - Action Method
    
    @objc private func playOrPauseButtonAction() {
        if viewModel.isRunning {
            viewModel.stopTimer()
            showPauseStatusView {
                self.runningMapView.mapView.setUserTrackingMode(.follow, animated: true)
            }
        } else {
            viewModel.startTimer()
            showPlayStatusView()
        }
    }
    
    private func showPauseStatusView( completion: @escaping () -> Void) {
        runningMapView.isHidden = false
        runningMapViewHeightConstraint.constant = self.view.frame.height * 0.3
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        completion()
    }
    
    private func showPlayStatusView() {
        runningMapViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.runningMapView.isHidden = true
        }
    }
    
    // MARK: - deinit
    deinit {
        print("deinit RecordView")
    }
}

extension RecordViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let mapSuperView = runningMapView.superview else { return nil }
        transition.originFrame = mapSuperView.convert(runningMapView.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

extension RecordViewController: PressGestureButtonDelegate {
    func animationComplete() {
        dismiss(animated: false) {
            self.viewModel.showSaveRecordView()
        }
    }
}
