//
//  NSFetchedResultsControllerDelegateProxy.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

// MARK: NSFetchedResultsControllerDelegateProxy
class NSFetchedResultsControllerDelegateProxy: DelegateProxy<NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate>, DelegateProxyType, NSFetchedResultsControllerDelegate {
    
    init(fetchedResultsController: ParentObject) {
        super.init(parentObject: fetchedResultsController, delegateProxy: NSFetchedResultsControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { NSFetchedResultsControllerDelegateProxy(fetchedResultsController: $0) }
    }
    
    static func currentDelegate(for object: NSFetchedResultsController<NSFetchRequestResult>) -> NSFetchedResultsControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: NSFetchedResultsControllerDelegate?, to object: NSFetchedResultsController<NSFetchRequestResult>) {
        object.delegate = delegate
    }
    
}
