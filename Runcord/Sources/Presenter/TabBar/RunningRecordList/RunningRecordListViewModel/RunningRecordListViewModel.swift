//
//  RunningRecordListViewModel.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/18.
//

import RxSwift
import RxCocoa

struct RunningRecordListViewModelAction {
    let showRunningRecordDetail: (RunningRecord) -> Void
}

final class RunningRecordListViewModel {
    
    private let runningRecordUseCase: RunningRecordUseCase
    private let actions: RunningRecordListViewModelAction
    
    private let runningRecordList: BehaviorRelay<RunningRecordList> = BehaviorRelay(value: RunningRecordList(list: []))
    private let disposeBag = DisposeBag()
    
    var runningRecordListDriver: Driver<[RunningRecord]> {
        return runningRecordList.map { $0.list }.asDriver(onErrorJustReturn: [])
    }
    
    init(runningRecordUseCase: RunningRecordUseCase, actions: RunningRecordListViewModelAction) {
        self.runningRecordUseCase = runningRecordUseCase
        self.actions = actions
    }
    
    func fetchRunningRecordList(completion: (() -> Void)? = nil) {
        runningRecordUseCase.fetchRunningRecordList().subscribe(with: self) { owner, result in
            owner.runningRecordList.accept(result)
            completion?()
        }.disposed(by: disposeBag)
    }
    
    func deleteRunningRecord(indexPath: IndexPath) {
        let runningList = runningRecordList.value
        do {
            try runningRecordUseCase.deleteRunningRecord(runningDate: runningList.list[indexPath.row].date)
        } catch {
            
        }
    }
    
    func showDetailRunningRecord(runningRecord: RunningRecord) {
        actions.showRunningRecordDetail(runningRecord)
    }
}
