//
//  DestinationStackView.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/25.
//

import UIKit

enum GoalType {
    case distance
    case time
}

class GoalSettingStackView: UIStackView {
    
    private enum Font {
        static let currentLabel: UIFont = UIFont.mediumNotoSansFont(ofSize: 22.0)
    }

    lazy var goalSettingLabelStackView: GoalSettingLabelStackView = {
        let stackView = GoalSettingLabelStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var currentLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        return stackView
    }()
    
    lazy var currentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let font = Font.currentLabel
        label.font = font
        return label
    }()
    
    lazy var buttonConfiguration: UIButton.Configuration = {
        var config = UIButton.Configuration.plain()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        config.preferredSymbolConfigurationForImage = imageConfig
        
        return config
    }()
    
    var goalType: GoalType
    
    init(goalType: GoalType) {
        self.goalType = goalType
        super.init(frame: .zero)
        setCurrentLabelStackView()
        setDestinationStackView()
        setTitle()
        spacing = 11
    }
    
    func setTitle() {
        switch goalType {
        case .distance:
            self.currentLabel.text = "킬로미터"
        case .time:
            self.currentLabel.text = "시간 : 분"
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDestinationStackView() {
        axis = .vertical
        alignment = .center
        addArrangedSubview(goalSettingLabelStackView)
        addArrangedSubview(currentLabelStackView)
    }
    
    private func setCurrentLabelStackView() {
        currentLabelStackView.addArrangedSubview(currentLabel)
        NSLayoutConstraint.activate([
            currentLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    
}

