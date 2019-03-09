//
//  Course+Extension.swift
//  DreamJob
//
//  Created by Vo Tung on 07/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

extension Course: PrimaryKeyEquatable {
    func hasSamePrimaryKey(with object: Course) -> Bool {
        if let id = id, let otherId = object.id {
            return id == otherId
        }
        return false
    }
}
