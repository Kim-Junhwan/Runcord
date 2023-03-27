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
        let font = UIFont(name: "NotoSansKR-Medium", size: 22.0)
        label.font = font
        return label
    }()
    
    lazy var buttonConfiguration: UIButton.Configuration = {
        var config = UIButton.Configuration.plain()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        config.preferredSymbolConfigurationForImage = imageConfig
        
        return config
    }()
    
    lazy var beforeButtonBackgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var beforeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.resizeImageTo(size: CGSize(width: 20, height: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        
        return button
    }()
    
    lazy var nextButtonBackgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "chevron.forward")?.resizeImageTo(size: CGSize(width: 20, height: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    var goalType: GoalType
    
    init(goalType: GoalType) {
        self.goalType = goalType
        super.init(frame: .zero)
        setCurrentLabelStackView()
        setDestinationStackView()
        setButtonConstraint()
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
        currentLabelStackView.addArrangedSubview(beforeButtonBackgroundView)
        currentLabelStackView.addArrangedSubview(currentLabel)
        currentLabelStackView.addArrangedSubview(nextButtonBackgroundView)
        NSLayoutConstraint.activate([
            currentLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setButtonConstraint() {
        beforeButtonBackgroundView.addSubview(beforeButton)
        nextButtonBackgroundView.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            beforeButtonBackgroundView.heightAnchor.constraint(equalToConstant: 44),
            beforeButtonBackgroundView.widthAnchor.constraint(equalToConstant: 44),
            
            nextButtonBackgroundView.heightAnchor.constraint(equalToConstant: 44),
            nextButtonBackgroundView.widthAnchor.constraint(equalToConstant: 44),
            
            beforeButton.topAnchor.constraint(equalTo: beforeButtonBackgroundView.topAnchor),
            beforeButton.leadingAnchor.constraint(equalTo: beforeButtonBackgroundView.leadingAnchor),
            beforeButton.trailingAnchor.constraint(equalTo: beforeButtonBackgroundView.trailingAnchor),
            beforeButton.bottomAnchor.constraint(equalTo: beforeButtonBackgroundView.bottomAnchor),
            
            nextButton.topAnchor.constraint(equalTo: nextButtonBackgroundView.topAnchor),
            nextButton.leadingAnchor.constraint(equalTo: nextButtonBackgroundView.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: nextButtonBackgroundView.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: nextButtonBackgroundView.bottomAnchor),
        ])
    }
    
}

