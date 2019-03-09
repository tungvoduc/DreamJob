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
    var selectJob: AnyObserver<ProfileJobListCollectionViewCellViewModelType> { get }
    var didSelectJob: Observable<ProfileJobListCollectionViewCellViewModelType> { get }
    func profileJobListCollectionViewCellViewModel(for job: Job) -> ProfileJobListCollectionViewCellViewModelType
}

// MARK: ProfileJobListViewModel
class ProfileJobListViewModel: ProfileJobListViewModelType {
    
    var selectJob: AnyObserver<ProfileJobListCollectionViewCellViewModelType>
    
    var didSelectJob: Observable<ProfileJobListCollectionViewCellViewModelType>
    
    var profile: Profile
    
    var jobs: [Job]
    
    init(profile: Profile, jobs: [Job]) {
        self.profile = profile
        self.jobs = jobs
        
        let selectJob = PublishSubject<ProfileJobListCollectionViewCellViewModelType>()
        self.selectJob = selectJob.asObserver()
        didSelectJob = selectJob.asObservable()
    }
    
    func profileJobListCollectionViewCellViewModel(for job: Job) -> ProfileJobListCollectionViewCellViewModelType {
        return ProfileJobListCollectionViewCellViewModel(profile: profile, job: job)
    }
    
}


