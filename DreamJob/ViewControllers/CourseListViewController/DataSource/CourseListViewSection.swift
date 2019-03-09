//
//  CourseListViewSection.swift
//  DreamJob
//
//  Created by Vo Tung on 08/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxDataSources

struct CourseListViewSection: SectionModelType {
    
    typealias Item = CourseCollectionViewCellViewModelType
    
    var items: [CourseCollectionViewCellViewModelType]
    
    init(original: CourseListViewSection, items: [CourseCollectionViewCellViewModelType]) {
        self = original
        self.items = items
    }
    
    init(items: [CourseCollectionViewCellViewModelType]) {
        self.items = items
    }
    
}
