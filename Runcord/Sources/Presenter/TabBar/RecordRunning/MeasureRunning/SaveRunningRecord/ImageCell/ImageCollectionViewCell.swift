//
//  ImageCollectionViewCell.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/09.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let reusableIdentifier = "ImageCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setImageViewSize()
    }
    
    private func setImageViewSize() {
    }

}
