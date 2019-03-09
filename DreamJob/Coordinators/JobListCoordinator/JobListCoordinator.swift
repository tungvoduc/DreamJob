//
//  JobListCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class JobListCoordinator: BaseCoordinator {
    
    let jobListViewController: JobListViewController
    
    init(profile: Profile, dataStack: CoreDataStack) {
        jobListViewController = JobListViewController(profile: profile, dataStack: dataStack)
        let navigationController = UINavigationController(rootViewController: jobListViewController)
        let router = Router(navigationController: navigationController)
        super.init(router: router)
    }
    
}
