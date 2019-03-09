//
//  JobListCollectionViewCellViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: JobListCollectionViewCellViewModelType
protocol JobListCollectionViewCellViewModelType {
    var name: NSAttributedString { get }
    var totalSkillsString: NSAttributedString { get }
    var job: Job { get }
}

// MARK: ProfileJobListCollectionViewCellViewModelType
protocol ProfileJobListCollectionViewCellViewModelType: JobListCollectionViewCellViewModelType {
    
    // Have to be ReplaySubject because of cell reusable
    var acquiredSkillsString: Observable<NSAttributedString> { get }
    var missingSkillsString: Observable<NSAttributedString> { get }
}

// MARK: ProfileJobListCollectionViewCellViewModel
class ProfileJobListCollectionViewCellViewModel: ProfileJobListCollectionViewCellViewModelType {
    
    var acquiredSkillsString: Observable<NSAttributedString>
    
    var missingSkillsString: Observable<NSAttributedString>
    
    var name: NSAttributedString
    
    var totalSkillsString: NSAttributedString
    
    private let disposeBag = DisposeBag()
    
    private(set) var job: Job
    
    init(acquiredSkills: Observable<Set<Skill>>, job: Job) {
        self.job = job
        
        let creator = JobViewModelDataCreator(acquiredSkills: acquiredSkills, job: job)
        name = creator.jobNameAttributedString()
        totalSkillsString = creator.totalSkillsString()
        acquiredSkillsString = creator.acquiredSkillsString(disposedBy: disposeBag)
        missingSkillsString = creator.missingSkillsString(disposedBy: disposeBag)
    }
    
}
