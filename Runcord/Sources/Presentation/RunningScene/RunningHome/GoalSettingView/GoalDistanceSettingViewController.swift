//
//  GoalDistanceSettingViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/14.
//

import Foundation

class GoalDistanceSettingViewController: BaseGoalSettingViewController {
    
    init() {
        super.init(goalType: .distance)
        distanceBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var setGoalDistance: ((Distance) -> Void)?
    
    private func distanceBind() {
        goalLabelBindingTextField.rx.text.orEmpty
            .withUnretained(self)
            .map({ owner, input in
                if input.isEmpty || input == "0" {
                    return "0"
                }
                if input == "00" {
                    owner.goalLabelBindingTextField.text?.removeLast()
                    return "0"
                }
                if input.filter({ $0 == "." }).count > 1 {
                    owner.goalLabelBindingTextField.text?.removeLast()
                    return owner.goalLabelBindingTextField.text
                }
                return input
            })
            .bind(to: self.goalLabel.goalSettingLabelStackView.destinationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func tapDoneButton() {
        guard let goalText = goalLabelBindingTextField.text else { fatalError() }
        setGoalDistance?(Distance(goalDistanceString: goalText))
        super.tapDoneButton()
    }
}
