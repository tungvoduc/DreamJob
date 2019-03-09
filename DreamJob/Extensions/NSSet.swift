//
//  NSSet.swift
//  DreamJob
//
//  Created by Vo Tung on 07/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

extension NSSet {
    
    func asSet<Type>(type: Type.Type) -> Set<Type>? {
        return self as? Set<Type>
    }
    
}
