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
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var runningFigureBaseView: UIView!
    @IBOutlet weak var runningFigureStackView: UIStackView!
    private var maxValue: Float?
    private var currentValue: Float = 0 {
        didSet {
            if let maxValue = maxValue, currentValue > maxValue {
                self.currentValue = maxValue
                return
            }
            bindFigureLabel()
        }
    }
    
    private lazy var runningFigureStackViewConstraint: NSLayoutConstraint = {
        return runningFigureStackView.leadingAnchor.constraint(equalTo: runningFigureBaseView.leadingAnchor)
    }()
    
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
        runningFigureStackView.translatesAutoresizingMaskIntoConstraints = false
        runningFigureStackViewConstraint.isActive = true
    }
    
    func setMaxValue(max: Float) {
        self.maxValue = max
    }
    
    func setCurrentValue(current: Float) {
        self.currentValue = current
    }
    
    func reversecurrentUserFigureLabel() {
        currentUserFigureLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    func bindFigureLabel() {
        guard let maxValue = maxValue else { return }
        let currentProgressBarLength = CGFloat((Float(currentValue)/Float(maxValue))) * goalProgressView.frame.width
        self.goalProgressView.setProgress((Float(currentValue)/Float(maxValue)), animated: true)
        runningFigureStackViewConstraint.constant = currentProgressBarLength
        print(currentProgressBarLength)
    }
    
}
