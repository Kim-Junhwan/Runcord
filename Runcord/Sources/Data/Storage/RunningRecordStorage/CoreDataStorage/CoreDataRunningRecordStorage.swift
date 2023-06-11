//
//  CoreDataRunningRecordStorage.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/26.
//

import CoreData
import RxSwift

final class CoreDataRunningRecordStroage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension CoreDataRunningRecordStroage: RunningRecordStorage {
    
    private func createRunningRecordFetchRequest() -> NSFetchRequest<RunningRecordEntity> {
        let request: NSFetchRequest = RunningRecordEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(RunningRecordEntity.date), ascending: false)]
        return request
    }
    
    func deleteRunningRecord(runningDate date: Date) throws {
        let context = coreDataStorage.managedContext
        let fetchRequest = RunningRecordEntity.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        fetchRequest.predicate = predicate
        do {
            let fetchEntity = try context.fetch(fetchRequest)
            guard let deleteEntity = fetchEntity.first else { return }
            context.delete(deleteEntity)
            try context.save()
        } catch {
            throw CoreDataStorageError.deleteError(error)
        }
    }
    
    func fetchRunningRecordList() -> Single<RunningRecordList> {
        return Single.create { single in
            let context = self.coreDataStorage.managedContext
            let request: NSFetchRequest = self.createRunningRecordFetchRequest()
            do {
                let result = try context.fetch(request).map { $0.toDomain() }
                single(.success(RunningRecordList(list: result)))
            } catch {
                single(.failure(CoreDataStorageError.readError(error)))
            }
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
}

