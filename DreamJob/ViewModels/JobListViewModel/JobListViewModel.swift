//
//  JobListViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift

// MARK: JobListViewModelType
protocol JobListViewModelType {
    var jobs: [Job] { get }
}

// MARK: JobListViewModelType
protocol ProfileJobListViewModelType: JobListViewModelType {
    var profile: Profile { get }
    var selectJob: AnyObserver<JobDetailViewModelType> { get }
    var didSelectJob: Observable<JobDetailViewModelType> { get }
    func profileJobListCollectionViewCellViewModel(for job: Job) -> ProfileJobListCollectionViewCellViewModelType
}

// MARK: ProfileJobListViewModel
class ProfileJobListViewModel: ProfileJobListViewModelType {
    
    var selectJob: AnyObserver<JobDetailViewModelType>
    
    var didSelectJob: Observable<JobDetailViewModelType>
    
    var profile: Profile
    
    var jobs: [Job]
    
    private let acquiredSkills: Observable<Set<Skill>>
    
    init(profile: Profile, jobs: [Job]) {
        self.profile = profile
        self.jobs = jobs
        acquiredSkills = profile.rx.acquiredSkills
            .share(replay: 1)
        
        let selectJob = PublishSubject<JobDetailViewModelType>()
        self.selectJob = selectJob.asObserver()
        didSelectJob = selectJob.asObservable()
    }
    
    func profileJobListCollectionViewCellViewModel(for job: Job) -> ProfileJobListCollectionViewCellViewModelType {
        return ProfileJobListCollectionViewCellViewModel(acquiredSkills: acquiredSkills, job: job)
    }
    
}


