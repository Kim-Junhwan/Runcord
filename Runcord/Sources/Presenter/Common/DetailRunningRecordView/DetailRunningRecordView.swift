//
//  DetailRunningRecordView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/21.
//

import UIKit
import CoreLocation

class DetailRunningRecordView: UIScrollView {
    
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var runningRecordMapImageView: CustomRouteMapImageView!
    
    // MARK: - Running Start Date Label
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    // MARK: - Running State Label
    @IBOutlet weak var runningHourLabel: UILabel!
    @IBOutlet weak var runningMinuteLabel: UILabel!
    
    // MARK: - Goal Label
    @IBOutlet weak var runningDistanceGoalLabel: UILabel!
    @IBOutlet weak var runningTimeGoalHourLabel: UILabel!
    @IBOutlet weak var runningTimeGoalMinuteLabel: UILabel!
    
    @IBOutlet weak var baseStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        if let view = Bundle.main.loadNibNamed("DetailRunningRecordView", owner: self)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
    
    func registerRunningRecord(runningRecord: RunningRecord) {
        setDateLabel(runningRecord: runningRecord)
        setRunningTimeLabel(runningRecord: runningRecord)
        setRunningDistanceLabel(runningRecord: runningRecord)
        setGoalLabel(runningRecord: runningRecord)
        runningRecordMapImageView.setRouteImage(route: runningRecord.runningPath.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
    }
    
    private func setDateLabel(runningRecord: RunningRecord) {
        let runningDate = runningRecord.date
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day, .hour, .minute], from: runningDate)
        yearLabel.text = String(describing: components.year!)
        monthLabel.text = String(describing: components.month!)
        dayLabel.text = String(describing: components.day!)
        
        hourLabel.text = String(describing: components.hour!)
        minuteLabel.text = String(describing: components.minute!)
    }
    
    private func setRunningTimeLabel(runningRecord: RunningRecord) {
        let runningTime = runningRecord.runningTime
        runningHourLabel.text = String(format: "%02d", runningTime / 3600)
        runningMinuteLabel.text = String(format: "%02d", (runningTime % 3600) / 60)
    }
    
    private func setRunningDistanceLabel(runningRecord: RunningRecord) {
        let runningDistance = runningRecord.runningDistance
        runningDistanceLabel.text = String(format: "%.2f", runningDistance)
    }
    
    private func setGoalLabel(runningRecord: RunningRecord) {
        let goalTime = runningRecord.goalTime
        let goalDistance = runningRecord.goalDistance
        
        runningDistanceGoalLabel.text = String(format: "%.2f", goalDistance)
        runningTimeGoalHourLabel.text = String(format: "%02d", goalTime / 3600)
        runningTimeGoalMinuteLabel.text = String(format: "%02d", (goalTime % 3600) / 60)
    }
    
}
