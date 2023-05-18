//
//  CoreDataRunningRecordStroage.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/17.
//

import Foundation
import RxSwift
import CoreData

final class CoreDataRunningRecordStroage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension CoreDataRunningRecordStroage {
    
    func fetchRecentRunningRecords() -> Observable<Result<[RunningRecord], Error>> {
        return Observable.create { observer in
            self.coreDataStorage.performBackgroundTask { context in
                do {
                    let request: NSFetchRequest = RunningRecordEntity.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: #keyPath(RunningRecordEntity.date), ascending: false), NSSortDescriptor(key: #keyPath(RunningRouteEntity.orderNum), ascending: true)]
                    let result = try context.fetch(request).map { $0.toDomain() }
                    observer.onNext(.success(result))
                } catch {
                    observer.onNext(.failure(CoreDataStorageError.readError(error)))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func saveRunningRecord(runningRecord: RunningRecord) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            let entity = RunningRecordEntity(runningRecord: runningRecord, insertInto: context)
            do {
                try context.save()
            } catch {
                print("cannot save \(error)")
            }
        }
    }
}
