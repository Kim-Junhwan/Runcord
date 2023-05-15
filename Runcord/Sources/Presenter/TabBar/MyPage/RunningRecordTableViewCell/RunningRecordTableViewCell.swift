//
//  RunningRecordTableViewCell.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/15.
//

import UIKit

class RunningRecordTableViewCell: UITableViewCell {
    
    static let identifier = "RunningRecordTableViewCell"
    
    @IBOutlet weak var runningRouteImageView: CustomRouteMapImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 20, dy: 5)
        contentView.layer.cornerRadius = 20.0
    }
    
}
