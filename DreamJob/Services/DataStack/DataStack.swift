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
    var managedObjectContext: NSManagedObjectContext { get }
    func createObject<Type: NSManagedObject>(ofType type: Type.Type) -> Type
    func deleteObject(_ object: NSManagedObject)
    func deleteAllRecords<Type: NSManagedObject>(ofType type: Type.Type, predicate: NSPredicate?)
    func allRecords<Type: NSManagedObject>(ofType type: Type.Type) -> [Type]
    func saveContext()
}

extension CoreDataStack {
    
    // Get fetch result controller
    func fetchResultController<ItemType: NSManagedObject>(type: ItemType.Type,
                                                          predicate: NSPredicate?,
                                                          sortDescriptors: [NSSortDescriptor]?,
                                                          sectionNameKeyPath: String?,
                                                          cacheName: String?) -> NSFetchedResultsController<ItemType> {
        let request = fetchRequest(type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        request.predicate = predicate
        
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
    }
    
    private func fetchRequest<ItemType: NSManagedObject>(type: ItemType.Type,
                                                         predicate: NSPredicate?,
                                                         sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<ItemType> {
        let entityName = String(describing: ItemType.self) // Work around for CoreData crash
        let request: NSFetchRequest<ItemType> = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        return request
    }
    
    private func fetchRequest(entityName: String,
                              predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<NSManagedObject> {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        return request
    }
    
    /// Return array of managed objects.
    /// - parameter predicate: Predicate used in fetch request
    /// - parameter sortDescriptors: sortDescriptors used in fetch request
    /// - parameter failure: execution for failed case
    func fetchObjects<ItemType: NSManagedObject>(type: ItemType.Type,
                                                 predicate: NSPredicate? = nil,
                                                 sortDescriptors: [NSSortDescriptor]? = nil,
                                                 failure: (() -> Void)? = nil) -> [ItemType]? {
        let request = fetchRequest(type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return fetchObjects(fetchRequest: request, failure: failure)
    }
    
    /// Return 1 managed object.
    /// - parameter predicate: Predicate used in fetch request
    /// - parameter sortDescriptors: sortDescriptors used in fetch request
    /// - parameter failure: execution for failed case
    func fetchObject<ItemType: NSManagedObject>(type: ItemType.Type,
                                                predicate: NSPredicate? = nil,
                                                sortDescriptors: [NSSortDescriptor]? = nil,
                                                failure: (() -> Void)?) -> ItemType? {
        let request = fetchRequest(type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        request.fetchLimit = 1
        return fetchObjects(fetchRequest: request, failure: failure)?.first
    }
    
    /// Return array of managed objects.
    /// - parameter fetchRequest: fetch request used to filtering and sorting result items.
    /// - parameter failure: execution for failed case
    func fetchObjects<ItemType: NSManagedObject>(fetchRequest: NSFetchRequest<ItemType>,
                                                 failure: (() -> Void)? = nil) -> [ItemType]? {
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result
        } catch {
            failure?()
        }
        
        return nil
    }
}

class DataStack: CoreDataStack {
    
    static var shared: DataStack = DataStack()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
                print(error.localizedDescription)
            }
        }
    }
}
