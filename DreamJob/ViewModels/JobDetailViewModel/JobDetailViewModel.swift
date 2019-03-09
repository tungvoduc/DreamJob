//
//  JobDetailViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: JobDetailViewModelType
protocol JobDetailViewModelType {
    var name: NSAttributedString { get }
    var totalSkillsString: NSAttributedString { get }
    var acquiredSkillsString: Observable<NSAttributedString> { get }
    var missingSkillsString: Observable<NSAttributedString> { get }
    var studyPathAlternativeCountString: Observable<NSAttributedString> { get }
}

// MARK: JobDetailViewModel
class JobDetailViewModel: JobDetailViewModelType {
    
    var name: NSAttributedString
    
    var totalSkillsString: NSAttributedString
    
    var acquiredSkillsString: Observable<NSAttributedString>
    
    var missingSkillsString: Observable<NSAttributedString>
    
    var studyPathAlternativeCountString: Observable<NSAttributedString>
    
    private let disposeBag = DisposeBag()
    
    init(acquiredSkills: Observable<Set<Skill>>, job: Job) {
        let creator = JobViewModelDataCreator(acquiredSkills: acquiredSkills, job: job)
        name = creator.jobNameAttributedString()
        totalSkillsString = creator.totalSkillsString()
        acquiredSkillsString = creator.acquiredSkillsString(disposedBy: disposeBag)
        missingSkillsString = creator.missingSkillsString(disposedBy: disposeBag)
        studyPathAlternativeCountString = creator.studyPathAlternativeCountString(disposedBy: disposeBag)
    }
    
}
