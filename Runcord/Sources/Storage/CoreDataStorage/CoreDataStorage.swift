//
//  CoreDataStorage.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/17.
//

import CoreData

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecordRunningStroage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Cannot load CoreDataStorage \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStroage Save Error \(error)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
