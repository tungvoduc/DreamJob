//
//  BaseCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 22/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

protocol CoordinatorType {
    var router: RouterType { get }
}

class BaseCoordinator: CoordinatorType, Presentable {
    
    let disposeBag = DisposeBag()
    
    private let id = UUID()
    
    var router: RouterType
    
    init(router: RouterType) {
        self.router = router
    }
    
    /// Child coordinators must be added to memory in order to keep it in memory
    private var childCoordinators: [UUID: Any] = [:]
    
    /// Add coordinator to `childCoordinators` dictionary
    func addCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators[coordinator.id] = coordinator
    }
    
    /// Remove coordinator to `childCoordinators` dictionary
    func removeCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators[coordinator.id] = nil
    }
    
    func toPresentable() -> UIViewController {
        return router.navigationController
    }
    
}
