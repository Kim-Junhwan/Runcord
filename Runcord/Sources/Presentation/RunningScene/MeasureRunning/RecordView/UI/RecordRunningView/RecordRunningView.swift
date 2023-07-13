//
//  RecordRunningView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/03.
//

import UIKit

protocol RecordRunningViewDelegate: AnyObject {
    func completeRunning()
    func playOrPauseAction()
}

class RecordRunningView: UIView {
    
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    @IBOutlet weak var completeButton: LongPressGestureButton!
    @IBOutlet weak var runningTimerLabel: UILabel!
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var goalDistanceProgressView: GoalProcessView!
    @IBOutlet weak var goalTimeProgressView: GoalProcessView!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    weak var delegate: RecordRunningViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("RecordRunningView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setControlButtonCornerRadius()
    }
    
    private func setControlButtonCornerRadius() {
        pauseAndPlayButton.layer.cornerRadius = pauseAndPlayButton.frame.height / 2
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
    }
    
    func setGoalDistanceProgressBar(goalDistance: Distance) {
        goalDistanceProgressView.setMaxValue(max: goalDistance.value)
        goalDistanceProgressView.currentUserFigureLabel.text = "🏃"
        goalDistanceProgressView.reversecurrentUserFigureLabel()
        goalDistanceProgressView.setCurrentValue(current: .zero)
    }
    
    func setGoalTimeProgressBar(goalTime: Time) {
        
        goalTimeProgressView.setMaxValue(max: Double(goalTime.totalSecond))
        goalTimeProgressView.currentUserFigureLabel.text = "⏰"
        goalTimeProgressView.setCurrentValue(current: .zero)
    }
    
    func setButtonPlayImage() {
        pauseAndPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    func setButtonPauseImage() {
        pauseAndPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func setCompleteButtonDelay(delayTime: Double) {
        completeButton.duringGestureTime = delayTime
    }
    
    
    @IBAction func playAndPauseButtonAction(_ sender: UIButton) {
        delegate?.playOrPauseAction()
    }
}

extension RecordRunningView: PressGestureButtonDelegate {
    func animationComplete() {
        delegate?.completeRunning()
    }
}
