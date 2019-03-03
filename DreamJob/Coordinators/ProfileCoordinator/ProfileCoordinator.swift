//
//  ProfileCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator {
    
    var profileViewController: ProfileViewController
    
    init(viewModel: ProfileViewModelType) {
        profileViewController = ProfileViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: profileViewController)
        super.init(router: Router(navigationController: navigationController))
    }
    
}
