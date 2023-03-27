//
//  CameraCollectionViewCell.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/17.
//

import UIKit

class CameraCollectionViewCell: UICollectionViewCell {

    static let identifier = "CameraCollectionViewCell"
    @IBOutlet weak var cameraButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tabCameraButton(_ sender: UIButton) {
    }
    
}
