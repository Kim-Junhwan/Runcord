//
//  RunningSaveButton.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/22.
//

import UIKit

class RunningSaveButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    func setButtonLayout() {
        backgroundColor = .tabBarSelect
        setTitleColor(.systemBackground, for: .normal)
        titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 19)
        titleLabel?.textColor = .systemBackground
        setTitle("러닝 저장하기", for: .normal)
    }
    
}
