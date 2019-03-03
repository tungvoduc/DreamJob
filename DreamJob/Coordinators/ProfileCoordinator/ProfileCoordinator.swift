//
//  ProfileCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileCoordinator: BaseCoordinator {
    
    var profileViewController: ProfileViewController
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ProfileViewModelType) {
        profileViewController = ProfileViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: profileViewController)
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
