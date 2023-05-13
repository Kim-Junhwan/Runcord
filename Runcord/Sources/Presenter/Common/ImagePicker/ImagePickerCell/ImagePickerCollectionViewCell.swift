//
//  ImagePickerCollectionViewCell.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/11.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImagePickerCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectMarkView: UIView!
    
    @IBOutlet weak var selectBackgroundView: UIView!
    @IBOutlet weak var selectOrderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelectMark()
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setSelectMark() {
        selectMarkView.layer.borderWidth = 6
        selectMarkView.layer.borderColor = UIColor.tabBarSelect.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectMarkView.isHidden = false
            } else {
                selectMarkView.isHidden = true
            }
        }
    }

}
