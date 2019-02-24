//
//  MockCoreDataStack.swift
//  DreamJobTests
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import CoreData
@testable import DreamJob

class MockCoreDataStack: CoreDataStack {
    
    var objectsDeletedCount = 0
    
    var allRecordsDeleted = false
    
    var didSaveContext = false
    
    var allRecords: [NSManagedObject] = []
    
    func createObject<Type>(ofType type: Type.Type) -> Type where Type : NSManagedObject {
        allRecordsDeleted = false
        return Type()
    }
    
    func deleteObject(_ object: NSManagedObject) {
        objectsDeletedCount += 1
    }
    
    func deleteAllRecords<Type>(ofType type: Type.Type, predicate: NSPredicate?) where Type : NSManagedObject {
        allRecordsDeleted = true
    }
    
    func allRecords<Type>(ofType type: Type.Type) -> [Type] where Type : NSManagedObject {
        if let allRecords = allRecords as? [Type] {
            return allRecords
        } else {
            return []
        }
    }
    
    func saveContext() {
        didSaveContext = true
    }
    
}
