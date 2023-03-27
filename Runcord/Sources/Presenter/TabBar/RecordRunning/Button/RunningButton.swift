//
//  BaseButton.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/14.
//

import UIKit

class RunningButton: UIButton {

    let discussionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setTitleLabel()
        setDiscussionLabel()
        setButtonShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func setTitleLabel() {
        guard let titleLabel = titleLabel else { return }
        titleLabel.font = UIFont(name: "NotoSansKR-Bold", size: 24)
        self.setTitleColor(.white, for: .normal)
    }
    
    private func setDiscussionLabel() {
        addSubview(discussionLabel)
        discussionLabel.font = UIFont(name: "NotoSansKR-Medium", size: 12)
        NSLayoutConstraint.activate([
            discussionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            discussionLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        ])
    }
    
    private func setButtonShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.masksToBounds = false
    }
    
    func setInset(height: CGFloat) {
        let buttonInset = height * (Double(14) / Double(1624))
        self.layoutMargins = UIEdgeInsets(top: buttonInset, left: buttonInset, bottom: buttonInset, right: buttonInset)
    }
}
