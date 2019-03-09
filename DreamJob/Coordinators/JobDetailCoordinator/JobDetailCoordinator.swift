//
//  JobDetailCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift

class JobDetailCoordinator: BaseCoordinator {
    
    var jobDetailViewController: JobDetailViewController
    
    private let disposeBag = DisposeBag()
    
    init(router: RouterType, viewModel: JobDetailViewModelType) {
        jobDetailViewController = JobDetailViewController(viewModel: viewModel)
        super.init(router: router)
    }
    
    override func toPresentable() -> UIViewController {
        return jobDetailViewController
    }
}
