//
//  RecordViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/01.
//

import UIKit
import RxSwift
import CoreLocation

class RecordViewController: UIViewController {
    
    @IBOutlet weak var runningMeasuringView: UIView!
    @IBOutlet weak var readyDiscussionLabel: UILabel!
    @IBOutlet weak var readyTimerLabel: UILabel!
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var completeButtonContainerView: UIView!
    @IBOutlet weak var runningTimerLabel: UILabel!
    private var completeButtonRingLayer: CAShapeLayer?
    @IBOutlet weak var goalDistanceProgressView: GoalProcessView!
    @IBOutlet weak var goalTimeProgressView: GoalProcessView!
    
    // MARK: - Properties
    private var timer: Timer?
    private var readyTimerNum = 5
    var viewModel: RecordViewModel
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runningMeasuringView.isHidden = true
        setControlButtonCornerRadius()
        startReadyTimer()
        setCompleteButton()
        setCompleteButtonRing()
        setGoalTimeProgress()
        setGoalDistanceProgress()
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
        
    }
    
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
    }
    
    // MARK: - Action Method

    @IBAction func tapPauseOrPlayButton(_ sender: Any) {
        if viewModel.isRunning {
            pauseAndPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            viewModel.stopTimer()
        } else {
            pauseAndPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            viewModel.startTimer()
        }
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
    
}
