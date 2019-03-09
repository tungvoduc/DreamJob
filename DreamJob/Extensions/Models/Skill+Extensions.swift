//
//  Skill+Extensions.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

extension Skill: PrimaryKeyEquatable {
    func hasSamePrimaryKey(with object: Skill) -> Bool {
        if let id = id, let otherId = object.id {
            return id == otherId
        }
        return false
    }
}
