//
//  GoalSettingStackView.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/26.
//

import UIKit

class GoalSettingLabelStackView: UIStackView {
    
    lazy var destinationLabel: UILabel = {
       let destinationLabel = UILabel()
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "NotoSansKR-Bold", size: 80)
        destinationLabel.font = font
        
        return destinationLabel
    }()
    
    lazy var underLineView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        addArrangedSubview(destinationLabel)
        addArrangedSubview(underLineView)
        heightAnchor.constraint(equalToConstant: 85).isActive = true
        setUnderLineView()
    }
    
    func setUnderLineView() {
        NSLayoutConstraint.activate([
            underLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
