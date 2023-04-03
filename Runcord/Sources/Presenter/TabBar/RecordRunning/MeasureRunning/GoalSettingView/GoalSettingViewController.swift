//
//  GoalSettingViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/27.
//

import UIKit
import RxCocoa
import RxSwift

class GoalSettingViewController: UIViewController {
    
    lazy var goalLabelBindingTextField: GoalTextField = {
        let textField = GoalTextField(goalType: goalType)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var goalLabel: GoalSettingStackView = {
        let goalLabel = GoalSettingStackView(goalType: goalType)
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return goalLabel
    }()
    
    private var disposeBag = DisposeBag()
    
    let goalType: GoalType
    
    var setGoalHandler: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = false
        setNavigationBarItem()
        setBindingTextField()
        setGoalLabel()
        setTextFieldSizeLimit()
        bindTextFieldToLabel()
        navigationItem.title = "러닝 목표 설정"
    }
    
    init(goalType: GoalType) {
        self.goalType = goalType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBindingTextField() {
        view.addSubview(goalLabelBindingTextField)
        goalLabelBindingTextField.becomeFirstResponder()
        NSLayoutConstraint.activate([
            goalLabelBindingTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            goalLabelBindingTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setGoalLabel() {
        view.addSubview(goalLabel)
        NSLayoutConstraint.activate([
            goalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setNavigationBarItem() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapCancelButton))
        let doneButton = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(tapDoneButton))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setTextFieldSizeLimit() {
        goalLabelBindingTextField.rx.text.orEmpty
            .asDriver()
            .map({ input in
                if input.contains(".") || input.contains(":") {
                    return input.count <= 5
                } else {
                    return input.count <= 4
                }
            })
            .drive { [weak self] in
                if !$0 {
                    self?.goalLabelBindingTextField.text = String(self?.goalLabelBindingTextField.text?.dropLast() ?? "")
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindTextFieldToLabel() {
        switch goalType {
        case .distance:
            distanceBind()
        case .time:
            timeBind()
        }
    }
    
    private func distanceBind() {
        goalLabelBindingTextField.rx.text.orEmpty
            .withUnretained(self)
            .map({ owner, input in
                if input.isEmpty {
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
    
    private func timeBind() {
        goalLabelBindingTextField.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, input in
                if input.isEmpty {
                    return "00:00"
                }
                if input == "0" {
                    owner.goalLabelBindingTextField.text?.removeLast()
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
    
    @objc func tapCancelButton() {
        closeKeyboard {
            self.dismiss(animated: false)
        }
    }
    
    private func closeKeyboard(completion: @escaping () -> Void) {
        view.endEditing(true)
        completion()
    }
    
    @objc func tapDoneButton() {
        if goalType == .distance {
            guard let goalText = goalLabelBindingTextField.text else { fatalError() }
            setGoalHandler?(goalText)
        } else {
            guard let goalText = goalLabel.goalSettingLabelStackView.destinationLabel.text else { fatalError() }
            setGoalHandler?(goalText)
        }
        closeKeyboard {
            self.dismiss(animated: false)
        }
    }
    
    private func convertToTime(num: Int) {
        
    }
    
    deinit {
        print("deinit setting goal view")
    }
}
