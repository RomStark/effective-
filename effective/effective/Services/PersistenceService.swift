//
//  PersistenceService.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import CoreData

final class PersistenceService {
    static let shared = PersistenceService()
    
    private let containerName = "effective"
    
    // Контейнер
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let ctx = context
        guard ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved Core Data save error \(nserror), \(nserror.userInfo)")
        }
    }
}
