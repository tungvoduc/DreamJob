//
//  TabbarCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class TabbarCoordinator: BaseCoordinator {
    
    var tabbarController: UITabBarController
    
    let profileCoordinator: ProfileCoordinator
    
    let jobListCoordinator: JobListCoordinator
    
    let courseListCoordinator: CourseListCoordinator
    
    init(profile: Profile, dataStack: CoreDataStack = DataStack.shared) {
        tabbarController = UITabBarController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: tabbarController)
        navigationController.isNavigationBarHidden = true
        let router = Router(navigationController: navigationController)
        
        // Other child coordinators
        jobListCoordinator = JobListCoordinator(profile: profile, dataStack: dataStack)
        
        profileCoordinator = ProfileCoordinator(viewModel: ProfileViewModel(profile: profile))
        
        courseListCoordinator = CourseListCoordinator(viewModel: CourseListViewModel(), profile: profile)
        
        super.init(router: router)
        
        tabbarCoordinators = [profileCoordinator, jobListCoordinator, courseListCoordinator]
        updateTabbarCoordinators(tabbarCoordinators)
    }
    
    var tabbarCoordinators: [BaseCoordinator]? {
        didSet {
            updateTabbarCoordinators(tabbarCoordinators)
        }
    }
    
    private func updateTabbarCoordinators(_ tabbarCoordinators: [BaseCoordinator]?) {
        if let tabbarCoordinators = tabbarCoordinators {
            tabbarController.viewControllers = tabbarCoordinators.map { $0.toPresentable() }
        } else {
            tabbarController.viewControllers = nil
        }
    }
    
    override func toPresentable() -> UIViewController {
        return tabbarController
    }
    
}
