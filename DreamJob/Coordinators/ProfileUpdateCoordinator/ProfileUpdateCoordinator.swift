//
//  ProfileUpdateCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class ProfileUpdateCoordinator: BaseCoordinator {
    
    var profileUpdateViewController: ProfileUpdateViewController
    
    init(viewModel: ProfileUpdateViewModeling) {
        profileUpdateViewController = ProfileUpdateViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: profileUpdateViewController)
        super.init(router: Router(navigationController: navigationController))
    }
    
}
