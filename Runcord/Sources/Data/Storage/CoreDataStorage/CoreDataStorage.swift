//
//  CoreDataStorage.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/17.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStorage {
    
    private enum Container {
        static let runningDataStorage: String = "RecordRunningStorage"
    }
    
    static let shared = CoreDataStorage()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Container.runningDataStorage)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Cannot load CoreDataStorage \(error)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = persistentContainer.viewContext
    
    func saveContext() throws {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                throw CoreDataStorageError.saveError(error)
            }
        }
    }
}
