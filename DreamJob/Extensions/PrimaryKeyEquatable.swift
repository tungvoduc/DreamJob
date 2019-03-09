//
//  PrimaryKeyEquatable.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

protocol PrimaryKeyEquatable {
    func hasSamePrimaryKey(with object: Self) -> Bool
}
