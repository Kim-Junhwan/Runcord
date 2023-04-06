//
//  GoalProcessView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/05.
//

import UIKit

class GoalProcessView: UIView {
    
    @IBOutlet weak var goalProgressView: UIProgressView!
    @IBOutlet weak var currentUserFigureLabel: UILabel!
    
    private var maxValue: Int = 100
    private var currentValue: Int = 0 {
        didSet {
            goalProgressView.setProgress(Float(currentValue)/Float(maxValue), animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("GoalProcessView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setMaxValue(max: Int) {
        self.maxValue = max
    }
    
    func setCurrentValue(current: Int) {
        self.currentValue = current
    }
    
}
