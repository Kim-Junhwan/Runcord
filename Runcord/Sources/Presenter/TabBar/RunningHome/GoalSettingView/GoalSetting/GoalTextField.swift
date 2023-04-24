//
//  DestinationTextField.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/25.
//

import UIKit
import RxCocoa

class GoalTextField: UITextField {
    
    var type: GoalType
    
    init(goalType: GoalType) {
        self.type = goalType
        super.init(frame: .zero)
        backgroundColor = .clear
        borderStyle = .none
        textColor = .clear
        setKeyboard()
    }
    
    func setKeyboard() {
        switch type {
        case .distance:
            self.keyboardType = .decimalPad
        case .time:
            self.keyboardType = .numberPad
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .null
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

}


