//
//  NSFetchedResultsController+Rx.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

extension Reactive where Base: NSFetchedResultsController<NSFetchRequestResult> {
    
    var delegate: NSFetchedResultsControllerDelegateProxy {
        return NSFetchedResultsControllerDelegateProxy.proxy(for: base)
    }
    
    var didChangeContent: Observable<NSFetchedResultsController<NSFetchRequestResult>> {
        
        do {
            try base.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        return delegate
            .methodInvoked(#selector(NSFetchedResultsControllerDelegate.controllerDidChangeContent(_:)))
            .map({ params -> NSFetchedResultsController<NSFetchRequestResult> in
                return params[0] as! NSFetchedResultsController<NSFetchRequestResult>
            })
            .startWith(base)
            .share(replay: 1)
    }
    
}
