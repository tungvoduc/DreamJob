//
//  UIViewController+Helpers.swift
//  DreamJobTests
//
//  Created by Vo Tung on 02/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func makeVisible() {
        let window = UIWindow()
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    
}
