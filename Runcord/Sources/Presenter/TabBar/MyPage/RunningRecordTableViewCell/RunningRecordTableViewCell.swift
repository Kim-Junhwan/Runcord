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
    
}
