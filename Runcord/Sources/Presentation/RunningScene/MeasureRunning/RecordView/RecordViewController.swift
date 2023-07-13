//
//  RecordViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/01.
//

import UIKit
import RxSwift
import MapKit

class RecordViewController: UIViewController {
    
    private enum Metric {
        static let mapHeightMultiplier: CGFloat = 0.3
        static let readyDelayTime: Int = 5
    }
    
    private enum AnimationMetric {
        static let mapAnimationTime: CGFloat = 0.2
        static let completeButtonGestureTime: Int = 2
    }
    
    private let recordRunningView: RecordRunningView = {
        let recordRunningView = RecordRunningView()
        recordRunningView.translatesAutoresizingMaskIntoConstraints = false
        return recordRunningView
    }()
    
    private let readyView: ReadyView = {
        let readyView = ReadyView(readyTime: Metric.readyDelayTime)
        readyView.translatesAutoresizingMaskIntoConstraints = false
        return readyView
    }()
    
    private let runningMapView: CustomMapView = {
        let customMapView = CustomMapView()
        customMapView.translatesAutoresizingMaskIntoConstraints = false
        return customMapView
    }()
    
    private lazy var runningMapViewHeightConstraint = runningMapView.heightAnchor.constraint(equalToConstant: .zero)
    
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
        recordRunningView.setGoalTimeProgressBar(goalTime: viewModel.goalTime)
        recordRunningView.setGoalDistanceProgressBar(goalDistance: viewModel.goalDistance)
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
        super.init(nibName: String(describing: RecordViewController.self), bundle: Bundle(for: RecordViewController.self))
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
        recordRunningView.completeButton.delegate = self
        recordRunningView.completeButton.duringGestureTime = AnimationMetric.completeButtonGestureTime
        recordRunningView.pauseAndPlayButton.addTarget(self, action: #selector(playOrPauseButtonAction), for: .touchUpInside)
    }
    
    // MARK: - Set MapView
    private func setMapView() {
        setMapViewTabGesture()
        runningMapView.mapViewIsScroolEnabled(false)
        runningMapView.mapViewIsZoomEnabled(false)
        runningMapView.mapViewSetUserTrackingMode()
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
            self.runningMapView.mapViewIsZoomEnabled(false)
            self.runningMapView.mapViewIsScroolEnabled(false)
            self.view.addSubview(runningMapView)
            NSLayoutConstraint.activate([
                runningMapView.topAnchor.constraint(equalTo: view.topAnchor),
                runningMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                runningMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                runningMapViewHeightConstraint
            ])
            runningMapViewHeightConstraint.constant = view.frame.height * Metric.mapHeightMultiplier
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
        viewModel.runningTime.asDriver().drive(with: self) { owner, time in
            owner.recordRunningView.runningTimerLabel.text = time.formatedTimeToString(format: .hourMinuteSecond)
            owner.recordRunningView.goalTimeProgressView.setCurrentValue(current: Double(time.totalSecond))
        }.disposed(by: disposeBag)

        viewModel.runningDistance.asDriver()
            .drive(onNext: { distance in
                self.recordRunningView.runningDistanceLabel.text = distance.formattedDistanceToString(type: .defaultFormat)
                self.recordRunningView.goalDistanceProgressView.setCurrentValue(current: distance.value)
            })
            .disposed(by: disposeBag)

        viewModel.routeDriver.drive(onNext: { route in
            if let lastCoordinate = route.first, let currentCoordinate = route.last {
                self.runningMapView.mapView.updateUserRoute(lastCoordinate: lastCoordinate, newCoordinate: currentCoordinate)
            }
        }).disposed(by: disposeBag)

        viewModel.averageSpeedDriver
            .map { $0.formattedSpeedToString(type: .defaultFormat) }
            .drive(recordRunningView.averageSpeedLabel.rx.text).disposed(by: disposeBag)
    }
    
    // MARK: - Action Method
    @objc private func playOrPauseButtonAction() {
        if viewModel.isRunning {
            viewModel.stopTimer()
            showPauseStatusView {
                self.runningMapView.mapView.setUserTrackingMode(.follow, animated: true)
            }
            return
        }
        viewModel.startTimer()
        showPlayStatusView()
    }
    
    private func showPauseStatusView( completion: @escaping () -> Void) {
        runningMapView.isHidden = false
        runningMapViewHeightConstraint.constant = self.view.frame.height * Metric.mapHeightMultiplier
        UIView.animate(withDuration: AnimationMetric.mapAnimationTime) {
            self.view.layoutIfNeeded()
        }
        completion()
    }
    
    private func showPlayStatusView() {
        runningMapViewHeightConstraint.constant = .zero
        UIView.animate(withDuration: AnimationMetric.mapAnimationTime) {
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
