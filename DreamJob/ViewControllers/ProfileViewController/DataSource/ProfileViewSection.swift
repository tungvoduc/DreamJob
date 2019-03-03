//
//  ProfileViewSection.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import RxDataSources

struct ProfileViewSection: SectionModelType {
    
    typealias Item = CourseCollectionViewCellViewModelType
    
    var items: [CourseCollectionViewCellViewModelType]
    
    init(original: ProfileViewSection, items: [CourseCollectionViewCellViewModelType]) {
        self = original
        self.items = items
    }
    
    init(items: [CourseCollectionViewCellViewModelType]) {
        self.items = items
    }
    
}
