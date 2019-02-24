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
    }
    
    override func toPresentable() -> UIViewController {
        return containerController
    }
    
    func currentViewController() -> UIViewController {
        if profileManager.hasProfile() {
            return ProfileViewController.fromNib()
        }
        
        return ProfileUpdateViewController.fromNib()
    }
    
    func setProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String) {
        let hasProfile = profileManager.hasProfile()
        
        profileManager.setProfile(with: email, studentId: studentId, firstName: firstName, lastName: lastName, socialSecurityNumber: socialSecurityNumber, dateOfBirth: dateOfBirth, address: address)
        
        if !hasProfile {
            containerController.show(currentViewController(), animated: true, completion: nil)
        }
    }
    
}
