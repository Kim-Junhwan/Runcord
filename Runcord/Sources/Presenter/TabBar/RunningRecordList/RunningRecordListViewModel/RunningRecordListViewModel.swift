//
//  RunningRecordListViewModel.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/18.
//

import RxSwift
import RxCocoa

final class RunningRecordListViewModel {
    
    private let runningRecordRepository: RunningRecordRepository
    
    private let runningRecordList: BehaviorSubject<[RunningRecord]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    
    var runningRecordListDriver: Driver<[RunningRecord]> {
        return runningRecordList.asDriver(onErrorJustReturn: [])
    }
    
    init(runningRecordRepository: RunningRecordRepository) {
        self.runningRecordRepository = runningRecordRepository
    }
    
    func fetchRunningRecordList() {
        runningRecordRepository.fetchRunningRecordList().subscribe(with: self) { owner, result in
            switch result {
            case .success(let runningList):
                owner.runningRecordList.on(.next(runningList))
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
}
