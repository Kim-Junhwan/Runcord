//
//  ReadyTimerView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/01.
//

import UIKit
import Foundation

class ReadyView: UIView {
    
    let sentenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .white
         label.font = UIFont(name: "NotoSansKR-Medium", size: 30)
        label.text = "러닝을 시작합니다"
         
         return label
     }()

    lazy var timerLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "NotoSansKR-Bold", size: 130)
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
            sentenceLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -30.0)
        ])
    }
    
    func startPrepare(completion: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.readyTime -= 1
            if self.readyTime <= 0 {
                timer.invalidate()
                completion()
            }
        })
    }
}
