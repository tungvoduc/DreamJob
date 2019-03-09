//
//  CourseListCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 08/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseListCoordinator: BaseCoordinator {
    
    var courseListViewController: CourseListViewController
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: CourseListViewModelType, profile: Profile) {
        courseListViewController = CourseListViewController(viewModel: viewModel, profile: profile)
        let navigationController = UINavigationController(rootViewController: courseListViewController)
        super.init(router: Router(navigationController: navigationController))
        
        viewModel.openCourseDetail
            .subscribe(onNext: {[weak self] course in
                if let strongSelf = self {
                    let coordinator = CourseDetailCoordinator(router: strongSelf.router, viewModel: course)
                    strongSelf.addCoordinator(coordinator)
                    strongSelf.router.push(coordinator, animated: true, completion: {
                        strongSelf.removeCoordinator(coordinator)
                    })
                }
            })
            .disposed(by: disposeBag)
        
    }
}
