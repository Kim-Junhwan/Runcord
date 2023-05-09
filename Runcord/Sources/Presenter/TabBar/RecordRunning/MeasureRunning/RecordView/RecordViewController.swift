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
    
    @IBOutlet weak var runningMeasuringView: UIView!
    @IBOutlet weak var readyDiscussionLabel: UILabel!
    @IBOutlet weak var readyTimerLabel: UILabel!
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var completeButtonContainerView: UIView!
    @IBOutlet weak var runningTimerLabel: UILabel!
    
    @IBOutlet weak var runningDistanceLabel: UILabel!
    private var completeButtonRingLayer: CAShapeLayer?
    @IBOutlet weak var goalDistanceProgressView: GoalProcessView!
    @IBOutlet weak var goalTimeProgressView: GoalProcessView!
    
    @IBOutlet weak var recordProgressStackView: UIStackView!
    let runningMapView: CustomMapView = {
       let customMapView = CustomMapView()
        customMapView.translatesAutoresizingMaskIntoConstraints = false
        
        return customMapView
    }()
    lazy var runningMapViewHeightConstraint = runningMapView.heightAnchor.constraint(equalToConstant: 0)
    
    // MARK: - Properties
    private var timer: Timer?
    private var readyTimerNum = 5
    var viewModel: RecordViewModel
    let disposeBag = DisposeBag()
    let transition = MapAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runningMeasuringView.isHidden = true
        setControlButtonCornerRadius()
        startReadyTimer()
        setCompleteButton()
        setCompleteButtonRing()
        setMapView()
        bind()
        setMapViewDismissCompletion()
        setGoalTimeProgress()
        setGoalDistanceProgress()
    }
    
    // MARK: - Initalizer
    init(viewModel: RecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RecordViewController", bundle: Bundle(for: RecordViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set MapView
    
    private func setMapView() {
        setMapViewTabGesture()
        runningMapView.mapView.isScrollEnabled = false
        runningMapView.mapView.isZoomEnabled = false
        runningMeasuringView.addSubview(runningMapView)
        
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
            self.runningMapView.mapView.setUserTrackingMode(.follow, animated: true)
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
    
    // MARK: - Set LocationManager
    
    // MARK: - Ready Time Method
    private func startReadyTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(readyTimerCallBack), userInfo: nil, repeats: true)
    }
    
    @objc func readyTimerCallBack() {
        readyTimerNum -= 1
        if readyTimerNum == 0 {
            timer?.invalidate()
            timer = nil
            hiddenTimerLabel()
            runningMeasuringView.isHidden = false
            viewModel.startTimer()
            viewModel.startTrackUserLocation()
        }
        readyTimerLabel.text = String(readyTimerNum)
    }
    
    // MARK: - Set Goal Progress
    
    private func setGoalDistanceProgress() {
        goalDistanceProgressView.setMaxValue(max: Float(viewModel.goalDistance))
        goalDistanceProgressView.reversecurrentUserFigureLabel()
        goalDistanceProgressView.setCurrentValue(current: 0)
    }
    
    private func setGoalTimeProgress() {
        goalTimeProgressView.setMaxValue(max: Float(viewModel.goalTime))
        goalTimeProgressView.currentUserFigureLabel.text = "⏰"
        goalTimeProgressView.setCurrentValue(current: 0)
    }
    
    // MARK: - Set UI Constraint
    private func setControlButtonCornerRadius() {
        pauseAndPlayButton.layer.cornerRadius = pauseAndPlayButton.frame.height / 2
        
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
    }
    
    private func hiddenTimerLabel() {
        readyDiscussionLabel.isHidden = true
        readyTimerLabel.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - bind
    private func bind() {
        viewModel.timerText.asDriver()
            .drive(runningTimerLabel.rx
                .text)
            .disposed(by: disposeBag)
        
        viewModel.totalRunningSecond.subscribe { currentTime in
            self.goalTimeProgressView.setCurrentValue(current: Float(currentTime))
        }
        .disposed(by: disposeBag)
        
        viewModel.runningDistance.asDriver()
            .drive(onNext: { distance in
                self.runningDistanceLabel.text = String(format: "%.2f", distance)
                self.goalDistanceProgressView.setCurrentValue(current: distance)
            })
            .disposed(by: disposeBag)
        
        viewModel.routeDriver.drive(onNext: { route in
            if let lastCoordinate = route.first, let currentCoordinate = route.last {
                self.runningMapView.mapView.updateUserRoute(lastCoordinate: lastCoordinate, newCoordinate: currentCoordinate)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Method

    @IBAction func tapPauseOrPlayButton(_ sender: Any) {
        if viewModel.isRunning {
            pauseAndPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            viewModel.stopTimer()
            showPauseStatusView()
        } else {
            pauseAndPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            viewModel.startTimer()
            showPlayStatusView()
        }
    }
    
    private func showPauseStatusView() {
        runningMapView.isHidden = false
        runningMapViewHeightConstraint.constant = self.view.frame.height * 0.3
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showPlayStatusView() {
        recordProgressStackView.isHidden = false
        runningMapViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.runningMapView.isHidden = true
        }
    }
    
    func setCompleteButton() {
        completeButton.addTarget(self, action: #selector(completeButtonTouchDown), for: .touchDown)
        //completeButton.addTarget(self, action: #selector(completeButtonTouchUp), for: .touchUpInside)
    }
    
    @objc func completeButtonTouchDown() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {[weak self] _ in
                let vc = SaveRecordRunningViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: {
                    self?.dismiss(animated: false)
                })
            })
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        completeButtonRingLayer?.add(animation, forKey: "animation")
    }
    
    @objc func completeButtonTouchUp() {
        completeButtonRingLayer?.removeAllAnimations()
        timer?.invalidate()
        timer = nil
        showToastMessage()
    }
    
    func showToastMessage() {
        print("show toast message ")
    }
    
    func setCompleteButtonRing() {
        let trackLayer = CAShapeLayer()
        trackLayer.frame = completeButton.bounds
        completeButtonRingLayer = CAShapeLayer()
        guard let completeButtonRingLayer = completeButtonRingLayer else { return }
        completeButtonContainerView.layer.addSublayer(completeButtonRingLayer)
        completeButtonRingLayer.path = UIBezierPath(arcCenter: trackLayer.position, radius: completeButton.frame.width/2+2, startAngle: .pi * (3/2), endAngle: .pi * (7/2), clockwise: true).cgPath
        completeButtonRingLayer.strokeColor = UIColor.black.cgColor
        completeButtonRingLayer.lineWidth = 4
        completeButtonRingLayer.fillColor = UIColor.clear.cgColor
        completeButtonRingLayer.strokeEnd = 0
    }
    // MARK: - deinit
    deinit {
        timer?.invalidate()
        timer = nil
        viewModel.deinitViewModel()
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
