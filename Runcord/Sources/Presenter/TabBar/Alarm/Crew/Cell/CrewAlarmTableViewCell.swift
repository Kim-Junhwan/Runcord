//
//  CrewAlarmTableViewCell.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/18.
//

import UIKit

class CrewAlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var crewIconImageView: UIImageView!
    @IBOutlet weak var alarmTypeLabel: UILabel!
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmCrewTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let identifier = "CrewAlarmReusableCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewMakeCircle()
    }
    
    func imageViewMakeCircle() {
        crewIconImageView.layer.cornerRadius = crewIconImageView.frame.width / 2.0
        crewIconImageView.layer.borderWidth = 1
        crewIconImageView.layer.borderColor = UIColor.darkGray.cgColor
        crewIconImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
