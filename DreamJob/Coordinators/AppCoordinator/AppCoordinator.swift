//
//  AppCoordinator.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import DTContainerController

final class AppCoordinator: BaseCoordinator {
    
    let containerController = DTContainerController(viewController: UIViewController())
    let profileManager: ProfileManaging
    let window: UIWindow
    
    private(set) var childCoordinator: BaseCoordinator!
    
    private let disposeBag = DisposeBag()
    
    init(window applicationWindow: UIWindow, router: RouterType = Router(navigationController: UINavigationController()), profileManager manager: ProfileManaging = ProfileManager()) {
        profileManager = manager
        window = applicationWindow
        super.init(router: router)
        
        childCoordinator = currentCoordinator()
        show(childCoordinator, animated: false, completion: nil)
        window.rootViewController = containerController
        window.makeKeyAndVisible()
    }
    
    override func toPresentable() -> UIViewController {
        return containerController
    }
    
    func currentCoordinator() -> BaseCoordinator {
        if let currentProfile = profileManager.currentProfile() {
            return ProfileCoordinator(viewModel: ProfileViewModel(profile: currentProfile))
        }
        
        let viewModel = ProfileUpdateViewModel()
        viewModel.didSetNewProfile
            .subscribe(onNext: {[weak self] profile in
                let coordinator = ProfileCoordinator(viewModel: ProfileViewModel(profile: profile))
                self?.childCoordinator = coordinator
                self?.show(coordinator, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        return ProfileUpdateCoordinator()
    }
    
    func show(_ coordinator: BaseCoordinator, animated: Bool, completion: (() -> Void)?) {
        childCoordinator = coordinator
        containerController.show(coordinator.toPresentable(), animated: animated, completion: completion)
    }
    
}
