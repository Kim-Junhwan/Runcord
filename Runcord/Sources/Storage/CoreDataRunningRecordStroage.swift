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
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let context = self.coreDataStorage.managedContext
            let request: NSFetchRequest = RunningRecordEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(RunningRecordEntity.date), ascending: false)]
                do {
                    let result = try context.fetch(request).map { $0.toDomain() }
                    observer.onNext(.success(result))
                } catch {
                    observer.onError(CoreDataStorageError.saveError(error))
                }
                observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func saveRunningRecord(runningRecord: RunningRecord) throws {
        let context = coreDataStorage.managedContext
        let entity = RunningRecordEntity(runningRecord: runningRecord, insertInto: context)
        do {
            try coreDataStorage.saveContext()
        } catch {
            throw CoreDataStorageError.saveError(error)
        }
    }
    
    func deleteRunningRecord(date: Date) throws {
        let context = coreDataStorage.managedContext
        let fetchRequest = RunningRecordEntity.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        fetchRequest.predicate = predicate
        do {
            let fetchEntity = try context.fetch(fetchRequest)
            guard let deleteEntity = fetchEntity.first else { return }
            context.delete(deleteEntity)
            do {
                try context.save()
            } catch {
                throw CoreDataStorageError.deleteError(error)
            }
        } catch {
            throw CoreDataStorageError.readError(error)
        }
    }
}
