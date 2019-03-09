//
//  JobListCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift

class JobListCoordinator: BaseCoordinator {
    
    let jobListViewController: JobListViewController
    
    private var disposebag = DisposeBag()
    
    init(profile: Profile, dataStack: CoreDataStack) {
        jobListViewController = JobListViewController(profile: profile, dataStack: dataStack)
        let navigationController = UINavigationController(rootViewController: jobListViewController)
        let router = Router(navigationController: navigationController)
        super.init(router: router)
        
        jobListViewController.viewModel.didSelectJob
            .subscribe(onNext: { [unowned self] viewModel in
                let coordinator = JobDetailCoordinator(router: self.router, viewModel: viewModel)
                self.addCoordinator(coordinator)
                self.router.push(coordinator, animated: true, completion: {
                    self.removeCoordinator(coordinator)
                })
            })
            .disposed(by: disposebag)
    }
    
}
