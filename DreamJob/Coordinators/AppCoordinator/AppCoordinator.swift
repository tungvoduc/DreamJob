//
//  AppCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import DTContainerController

final class AppCoordinator: BaseCoordinator {
    
    let containerController = DTContainerController(viewController: UIViewController())
    let profileManager: ProfileManaging
    let window: UIWindow
    
    init(window applicationWindow: UIWindow, router: RouterType = Router(navigationController: UINavigationController()), profileManager manager: ProfileManaging = ProfileManager()) {
        profileManager = manager
        window = applicationWindow
        super.init(router: router)
        containerController.show(currentViewController(), animated: false, completion: nil)
        window.rootViewController = containerController
        window.makeKeyAndVisible()
    }
    
    override func toPresentable() -> UIViewController {
        return containerController
    }
    
    func currentViewController() -> UIViewController {
        if let currentProfile = profileManager.currentProfile() {
            return ProfileViewController(viewModel: ProfileViewModel(profile: currentProfile))
        }
        
        return ProfileUpdateViewController(viewModel: ProfileUpdateViewModel())
    }
    
}
