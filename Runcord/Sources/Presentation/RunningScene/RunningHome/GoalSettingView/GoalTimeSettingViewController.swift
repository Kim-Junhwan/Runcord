//
//  GoalTimeSettingViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/14.
//

import Foundation

class GoalTimeSettingViewController: BaseGoalSettingViewController {
    
    init(time: Time) {
        super.init(goalType: .time)
        if time.hour > 0 {
            self.goalLabelBindingTextField.text = time.formatedTimeToString(format: .goalTimeSettingFormat)
        } else {
            self.goalLabelBindingTextField.text = String(time.minute)
        }
        timeBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var setGoalTime: ((Time) -> Void)?
    
    private func timeBind() {
        goalLabelBindingTextField.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, input in
                if input.isEmpty {
                    return "00:00"
                }
                if input == "0" || input == "00"{
                    owner.goalLabelBindingTextField.text?.removeAll()
                    return "00:00"
                }
                let len = input.count
                let paddedStr = String(repeating: "0", count: 4 - len) + input
                let index1 = paddedStr.index(paddedStr.startIndex, offsetBy: 2)
                let index2 = paddedStr.index(paddedStr.startIndex, offsetBy: 4)
                let result = "\(paddedStr[..<index1]):\(paddedStr[index1..<index2])"
                return result
            }
            .bind(to: self.goalLabel.goalSettingLabelStackView.destinationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func tapDoneButton() {
        guard let goalText = goalLabel.goalSettingLabelStackView.destinationLabel.text else { fatalError() }
        setGoalTime?(Time(goalTimeString: goalText))
        super.tapDoneButton()
    }
}
