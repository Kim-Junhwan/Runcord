//
//  ReadyTimerView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/01.
//

import UIKit
import Foundation

class ReadyView: UIView {
    
    private enum Metric {
        static let sentenceLabelTop: CGFloat = -30.0
    }
    
    private enum TimerMetric {
        static let timerInterval: Double = 1.0
    }
    
    private enum Font {
        static let sentenceLabel: UIFont = UIFont.mediumNotoSansFont(ofSize: 30.0)
        static let timerLabel: UIFont = UIFont.boldNotoSansFont(ofSize: 130.0)
    }
    
    private enum Text {
        static let sentenceLabel: String = "러닝을 시작합니다"
    }
    
    let sentenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = Font.sentenceLabel
        label.text = Text.sentenceLabel
        return label
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = Font.timerLabel
        label.text = "\(readyTime)"
        return label
    }()
    
    private var timer: Timer?
    
    private var readyTime: Int {
        didSet {
            self.timerLabel.text = String(readyTime)
        }
    }
    
    init(readyTime: Int) {
        self.readyTime = readyTime
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(sentenceLabel)
        addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sentenceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            sentenceLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: Metric.sentenceLabelTop)
        ])
    }
    
    func startPrepare(completion: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: TimerMetric.timerInterval, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.readyTime -= Int(TimerMetric.timerInterval)
            if self.readyTime <= .zero {
                timer.invalidate()
                completion()
            }
        })
    }
}
