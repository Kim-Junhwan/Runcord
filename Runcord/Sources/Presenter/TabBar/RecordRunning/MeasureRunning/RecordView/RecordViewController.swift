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
    @IBOutlet weak var mapView: MKMapView!
    // MARK: - Properties
    private var timer: Timer?
    private var readyTimerNum = 5
    var viewModel: RecordViewModel
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        runningMeasuringView.isHidden = true
        setControlButtonCornerRadius()
        startReadyTimer()
        setCompleteButton()
        setCompleteButtonRing()
        setGoalTimeProgress()
        setGoalDistanceProgress()
        setMapView()
        
        bind()
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
        mapView.delegate = self
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
    }
    
    private func setGoalTimeProgress() {
        goalTimeProgressView.setMaxValue(max: Float(viewModel.goalTime))
        goalTimeProgressView.currentUserFigureLabel.text = "⏰"
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
        recordProgressStackView.isHidden = true
        mapView.isHidden = false
    }
    
    private func showPlayStatusView() {
        recordProgressStackView.isHidden = false
        mapView.isHidden = true
    }
    
    func setCompleteButton() {
        completeButton.addTarget(self, action: #selector(completeButtonTouchDown), for: .touchDown)
        completeButton.addTarget(self, action: #selector(completeButtonTouchUp), for: .touchUpInside)
    }
    
    @objc func completeButtonTouchDown() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {[weak self] timer in
                let vc = SaveRecordRunningViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
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
    
    // MARK: - CompleteButton Action Method
    
    // MARK: - deinit
    deinit {
        timer?.invalidate()
        timer = nil
        viewModel.deinitViewModel()
        print("deinit record viewcontroller")
    }
}

extension RecordViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        if !viewModel.route.isEmpty {
            mapView.updateUserRoute(lastCoordinate: viewModel.route.last!, newCoordinate: currentLocation)
        }
        mapView.centerToLocation(location: currentLocation)
        viewModel.route.append(currentLocation)
    }
}

extension RecordViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { fatalError() }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .orange
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
