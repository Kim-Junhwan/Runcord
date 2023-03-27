//
//  RunningStartViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/01.
//

import Foundation
import RxCocoa
import RxSwift

class RunningStartViewModel {
    
    let viewTitle: String
    
    var goalDistance: BehaviorRelay<Float> = BehaviorRelay<Float>(value: 5.00)
    var goalHour: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var goalMinute: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var goalTimeRelay = BehaviorRelay<String>(value: "")
    
    let disposeBag = DisposeBag()
    
    init(viewTitle: String) {
        self.viewTitle = viewTitle
        Observable.combineLatest(goalHour, goalMinute).map({ hour, minute in
            "\(String(format: "%.2d", hour)):\(String(format: "%.2d", minute))"
        }).bind(to: goalTimeRelay)
            .disposed(by: disposeBag)
    }
    
}
