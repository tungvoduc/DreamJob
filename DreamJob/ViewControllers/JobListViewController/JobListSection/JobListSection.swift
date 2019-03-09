//
//  JobListSection.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import RxDataSources

struct JobListSection: SectionModelType {
    
    typealias Item = ProfileJobListCollectionViewCellViewModelType
    
    var items: [ProfileJobListCollectionViewCellViewModelType]
    
    init(original: JobListSection, items: [ProfileJobListCollectionViewCellViewModelType]) {
        self = original
        self.items = items
    }
    
    init(items: [ProfileJobListCollectionViewCellViewModelType]) {
        self.items = items
    }
    
}
