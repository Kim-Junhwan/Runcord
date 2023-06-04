//
//  RecordRunningView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/03.
//

import UIKit

class RecordRunningView: UIView {
    
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    @IBOutlet weak var completeButton: LongPressGestureButton!
    @IBOutlet weak var runningTimerLabel: UILabel!
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var goalDistanceProgressView: GoalProcessView!
    @IBOutlet weak var goalTimeProgressView: GoalProcessView!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
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
    
    func setGoalDistanceProgressBar(maxValue: Double) {
        goalDistanceProgressView.setMaxValue(max: maxValue)
        goalDistanceProgressView.currentUserFigureLabel.text = "🏃"
        goalDistanceProgressView.reversecurrentUserFigureLabel()
        goalDistanceProgressView.setCurrentValue(current: 0)
    }
    
    func setGoalTimeProgressBar(maxValue: Double) {
        goalTimeProgressView.setMaxValue(max: maxValue)
        goalTimeProgressView.currentUserFigureLabel.text = "⏰"
        goalTimeProgressView.setCurrentValue(current: 0)
    }
    
    func setButtonPlayImage() {
        pauseAndPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    func setButtonPauseImage() {
        pauseAndPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
}
