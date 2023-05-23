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
    private let coordinator: RunningListCoordinator
    
    private let runningRecordList: BehaviorRelay<[RunningRecord]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    var runningRecordListDriver: Driver<[RunningRecord]> {
        return runningRecordList.asDriver(onErrorJustReturn: [])
    }
    
    init(runningRecordRepository: RunningRecordRepository, coordinator: RunningListCoordinator) {
        self.runningRecordRepository = runningRecordRepository
        self.coordinator = coordinator
    }
    
    func fetchRunningRecordList(completion: (() -> Void)? = nil) {
        runningRecordRepository.fetchRunningRecordList().subscribe(with: self) { owner, result in
            switch result {
            case .success(let runningList):
                owner.runningRecordList.accept(runningList)
                completion?()
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    
    func deleteRunningRecord(indexPath: IndexPath) {
        let runningList = runningRecordList.value
        runningRecordRepository.deleteRunningRecord(runingDate: runningList[indexPath.row].date)
    }
    
    func showDetailRunningRecord(runningRecord: RunningRecord) {
        coordinator.showDetailRunningRecord(runningRecord: runningRecord)
    }
}
