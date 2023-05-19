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
    
    @IBOutlet weak var runningRouteImageView: CustomRouteMapImageView!
    @IBOutlet weak var startDatelabel: UILabel!
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var runningPaceLabel: UILabel!
    @IBOutlet weak var runningTimeHourLabel: UILabel!
    @IBOutlet weak var runningTimeMinuteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 20, dy: 5)
        contentView.layer.cornerRadius = 20.0
    }
    
    func setData(runningRecord: RunningRecord) {
        runningRouteImageView.setRouteImage(route: runningRecord.runningPath.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
        runningDistanceLabel.text = String(format: "%.2f", runningRecord.runningDistance)
    }
    
}
