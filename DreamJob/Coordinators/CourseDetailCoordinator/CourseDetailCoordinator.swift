//
//  CourseDetailCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class CourseDetailCoordinator: BaseCoordinator {
    
    let courseDetailViewController: CourseDetailViewController
    
    init(router: RouterType, viewModel: CourseDetailViewModelType) {
        courseDetailViewController = CourseDetailViewController(viewModel: viewModel)
        super.init(router: router)
    }
    
    override func toPresentable() -> UIViewController {
        return courseDetailViewController
    }
}
