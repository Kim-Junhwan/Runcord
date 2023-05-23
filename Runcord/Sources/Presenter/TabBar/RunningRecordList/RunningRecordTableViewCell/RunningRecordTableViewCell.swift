//
//  RunningRecordTableViewCell.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/15.
//

import UIKit
import CoreLocation

class RunningRecordTableViewCell: UITableViewCell {
    
    static let identifier = "RunningRecordTableViewCell"
    
    @IBOutlet weak var runningYearLabel: UILabel!
    @IBOutlet weak var runningStartMonthLabel: UILabel!
    @IBOutlet weak var runningStartDayLabel: UILabel!
    
    @IBOutlet weak var runningStartHourLabel: UILabel!
    @IBOutlet weak var runningStartMinuteLabel: UILabel!
    
    @IBOutlet weak var runningRouteImageView: CustomRouteMapImageView!
    @IBOutlet weak var startDatelabel: UILabel!
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var runningPaceLabel: UILabel!
    @IBOutlet weak var runningTimeHourLabel: UILabel!
    @IBOutlet weak var runningTimeMinuteLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 20, dy: 5)
        contentView.layer.cornerRadius = 20.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        runningRouteImageView.image = nil
    }
    
    func setData(runningRecord: RunningRecord) {
        runningRouteImageView.setRouteImage(route: runningRecord.runningPath.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
        runningDistanceLabel.text = String(format: "%.2f", runningRecord.runningDistance)
        setDateLabel(runningRecord: runningRecord)
        setRunningTimeLabel(runningRecord: runningRecord)
        averageSpeedLabel.text = String(format: "%.2f", runningRecord.averageSpeed)
    }
    
    private func setDateLabel(runningRecord: RunningRecord) {
        let runningDate = runningRecord.date
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day, .hour, .minute], from: runningDate)
        runningYearLabel.text = String(describing: components.year!)
        runningStartMonthLabel.text = String(describing: components.month!)
        runningStartDayLabel.text = String(describing: components.day!)
        
        runningStartHourLabel.text = String(describing: components.hour!)
        runningStartMinuteLabel.text = String(describing: components.minute!)
    }
    
    private func setRunningTimeLabel(runningRecord: RunningRecord) {
        let runningTime = runningRecord.runningTime
        runningTimeHourLabel.text = String(format: "%02d", runningTime / 3600)
        runningTimeMinuteLabel.text = String(format: "%02d", (runningTime % 3600) / 60)
    }
}
