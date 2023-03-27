//
//  AddImageCollectionViewCell.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/09.
//

import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addCellBackgroundView: UIView!
    static let identifier = "AddImageCollectionViewCell"

    @IBOutlet weak var imageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCellBackgroundView.layer.borderWidth = 2
        addCellBackgroundView.layer.borderColor = UIColor.gray.cgColor
    }

}
