//
//  DataStack.swift
//  DreamJob
//
//  Created by Vo Tung on 21/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStack {
    func createObject<Type: NSManagedObject>(ofType type: Type.Type) -> Type
    func deleteObject(_ object: NSManagedObject)
    func deleteAllRecords<Type: NSManagedObject>(ofType type: Type.Type, predicate: NSPredicate?)
    func allRecords<Type: NSManagedObject>(ofType type: Type.Type) -> [Type]
    func saveContext()
}

class DataStack: CoreDataStack {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DreamJob")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createObject<Type: NSManagedObject>(ofType type: Type.Type) -> Type {
        return NSEntityDescription.insertNewObject(forEntityName: entityName(for: type), into: viewContext) as! Type
    }
    
    func deleteObject(_ object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
    }
    
    func deleteObjects(_ objects: [NSManagedObject]) {
        objects.forEach { persistentContainer.viewContext.delete($0) }
    }
    
    func allRecords<Type>(ofType type: Type.Type) -> [Type] where Type : NSManagedObject {
        let request = fetchRequest(ofType: type)
        
        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    func deleteAllRecords<Type: NSManagedObject>(ofType type: Type.Type, predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<NSFetchRequestResult> = fetchRequest(ofType: type) as! NSFetchRequest<NSFetchRequestResult>
        request.predicate = predicate
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            if let coordinator = viewContext.persistentStoreCoordinator {
                try coordinator.execute(delete, with: viewContext)
            }
        } catch {
            print("Cannot delete \(type) objects")
        }
    }
    
    private func fetchRequest<Type: NSManagedObject>(ofType type: Type.Type) -> NSFetchRequest<Type> {
        return NSFetchRequest(entityName: entityName(for: type))
    }
    
    private func entityName<Type: NSManagedObject>(for type: Type.Type) -> String {
        return String(describing: type)
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
