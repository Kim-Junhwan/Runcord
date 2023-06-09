//
//  DetailRunningRecordView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/21.
//

import CoreLocation
import UIKit

class DetailRunningRecordView: UIView {
    
    private enum TimeMetric {
        static let hourToSecond: Int = 3600
        static let minuteToSecond: Int = 60
        static let format: String = "%02d"
    }
    
    private enum DistanceMetric {
        static let format: String = "%.2f"
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
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
        if let view = Bundle.main.loadNibNamed(String(describing: DetailRunningRecordView.self), owner: self)?.first as? UIView {
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
        averageSpeedLabel.text = String(format: DistanceMetric.format, runningRecord.averageSpeed)
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
        runningHourLabel.text = String(format: TimeMetric.format, runningTime / TimeMetric.hourToSecond)
        runningMinuteLabel.text = String(format: TimeMetric.format, (runningTime % TimeMetric.hourToSecond) / TimeMetric.minuteToSecond)
    }
    
    private func setRunningDistanceLabel(runningRecord: RunningRecord) {
        let runningDistance = runningRecord.runningDistance
        runningDistanceLabel.text = String(format: DistanceMetric.format, runningDistance)
    }
    
    private func setGoalLabel(runningRecord: RunningRecord) {
        let goalTime = runningRecord.goalTime
        let goalDistance = runningRecord.goalDistance
        
        runningDistanceGoalLabel.text = String(format: DistanceMetric.format, goalDistance)
        runningTimeGoalHourLabel.text = String(format: TimeMetric.format, goalTime / TimeMetric.hourToSecond)
        runningTimeGoalMinuteLabel.text = String(format: TimeMetric.format, (goalTime % TimeMetric.hourToSecond) / TimeMetric.minuteToSecond)
    }
    
}
