//
//  LocationButton.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/14.
//

import UIKit

class LocationButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setImage(UIImage(named: "Location"), for: .normal)
        titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        setTitleColor(.black, for: .normal)
    }
    
    private func setConfiguration() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Location")
        config.imagePadding = 8
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        var titleAttr = AttributedString.init("주소를 입력하세요")
        titleAttr.foregroundColor = .black
        titleAttr.font = .boldSystemFont(ofSize: 16)
        config.attributedTitle = titleAttr
        self.configuration = config
    }

}
