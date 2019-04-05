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
        jobListCoordinator.toPresentable().tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(named: "JobNormal"), selectedImage: UIImage(named: "JobSelected"))
        
        profileCoordinator = ProfileCoordinator(viewModel: ProfileViewModel(profile: profile))
        profileCoordinator.toPresentable().tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ProfileNormal"), selectedImage: UIImage(named: "ProfileSelected"))
        
        courseListCoordinator = CourseListCoordinator(viewModel: CourseListViewModel(profile: profile), profile: profile)
        courseListCoordinator.toPresentable().tabBarItem = UITabBarItem(title: "Courses", image: UIImage(named: "CourseNormal"), selectedImage: UIImage(named: "CourseSelected"))
        
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
