//
//  UIViewController+Helper.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

extension UINib {
    
    static func viewController<Type: UIViewController>(from type: Type.Type) -> Type {
        return Type(nibName: String(describing: type), bundle: nil)
    }
    
}

extension UIViewController {
    class func fromNib() -> Self {
        return UINib.viewController(from: self)
    }
}
