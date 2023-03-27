//
//  MenuBarCell.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/15.
//

import UIKit

class MenuBarCell: UICollectionViewCell {
    
    static let reusableIdentifier = "MenuBarCell"
    
    lazy var itemTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.itemTitle.font = isSelected ? UIFont(name: "NotoSansKR-Bold", size: 16) : UIFont(name: "NotoSansKR-Medium", size: 16)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(itemTitle)
        NSLayoutConstraint.activate([
            itemTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
