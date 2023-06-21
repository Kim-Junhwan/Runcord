//
//  GoalProcessView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/05.
//

import UIKit

class GoalProcessView: UIView {
    
    private enum Progress {
        static let maxValue: Double = 1.0
        static let minValue: Double = 0.0
    }
    
    private enum ImageDirection {
        static let x: CGFloat = -1.0
        static let y: CGFloat = 1.0
    }
    
    @IBOutlet weak var goalProgressView: UIProgressView!
    @IBOutlet weak var currentUserFigureLabel: UILabel!
    @IBOutlet weak var runningFigureBaseView: UIView!
    private var maxValue: Double?
    private var currentValue: Double = Progress.minValue {
        didSet {
            if let maxValue = maxValue, currentValue > maxValue {
                self.currentValue = maxValue
                return
            }
            bindFigureLabel()
        }
    }
    private var isMax: Bool = false
    
    private lazy var currentUserFigureLabelConstraint: NSLayoutConstraint = {
        return currentUserFigureLabel.leadingAnchor.constraint(equalTo: runningFigureBaseView.leadingAnchor)
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
        currentUserFigureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentUserFigureLabel.centerYAnchor.constraint(equalTo: runningFigureBaseView.centerYAnchor),
            currentUserFigureLabel.widthAnchor.constraint(equalTo: runningFigureBaseView.widthAnchor, multiplier: 0.1),
            currentUserFigureLabelConstraint
        ])
    }
    
    func setMaxValue(max: Double) {
        if max == Progress.minValue {
            self.maxValue = Progress.maxValue
            self.currentValue = Progress.maxValue
            isMax = true
            return
        }
        self.maxValue = max
    }
    
    func setCurrentValue(current: Double) {
        guard let maxValue = maxValue else { return }
        if !isMax {
            if currentValue >= maxValue {
                isMax = true
            }
            self.currentValue = current
        }
    }
    
    func reversecurrentUserFigureLabel() {
        currentUserFigureLabel.transform = CGAffineTransform(scaleX: ImageDirection.x, y: ImageDirection.y)
    }
    
    func bindFigureLabel() {
        guard let maxValue = maxValue else { return }
        let currentProgressBarLength = CGFloat((Float(currentValue)/Float(maxValue))) * goalProgressView.frame.width
        self.goalProgressView.setProgress((Float(currentValue)/Float(maxValue)), animated: true)
        currentUserFigureLabelConstraint.constant = currentProgressBarLength
    }
    
    
}
