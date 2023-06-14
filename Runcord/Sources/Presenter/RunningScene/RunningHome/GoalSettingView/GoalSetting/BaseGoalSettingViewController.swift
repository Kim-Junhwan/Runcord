//
//  GoalSettingViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/27.
//

import UIKit
import RxCocoa
import RxSwift

class BaseGoalSettingViewController: UIViewController {
    
    private enum Title {
        static let navigationTitle: String = "러닝 목표 설정"
        static let cancelButtonTitle: String = "취소"
        static let doneButtonTitle: String = "설정"
    }
    
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
    
    var disposeBag = DisposeBag()
    
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
        navigationItem.title = Title.navigationTitle
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
        let cancelButton = UIBarButtonItem(title: Title.cancelButtonTitle, style: .plain, target: self, action: #selector(tapCancelButton))
        let doneButton = UIBarButtonItem(title: Title.doneButtonTitle, style: .plain, target: self, action: #selector(tapDoneButton))
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
                }
                return input.count <= 4
            })
            .drive { [weak self] in
                if !$0 {
                    self?.goalLabelBindingTextField.text = String(self?.goalLabelBindingTextField.text?.dropLast() ?? "")
                }
            }.disposed(by: disposeBag)
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
        closeKeyboard {
            self.dismiss(animated: false)
        }
    }
    
    deinit {
        print("deinit setting goal view")
    }
}
