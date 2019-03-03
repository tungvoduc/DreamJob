//
//  ProfileViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 25/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: ProfileViewModelType
protocol ProfileViewModelType: ProfileBasedViewModelType {
    var basicProfileInfo: BasicProfileInfoViewModelType { get }
    var completedCourses: Observable<[CourseCollectionViewCellViewModelType]> { get }
    
    var selectCourseDetail: AnyObserver<CourseDetailViewModelType> { get }
    var openCourseDetail: Observable<CourseDetailViewModelType> { get }
}

// MARK: ProfileViewModel
class ProfileViewModel: ProfileViewModelType {
    
    var selectCourseDetail: AnyObserver<CourseDetailViewModelType>
    
    var openCourseDetail: Observable<CourseDetailViewModelType>
    
    var basicProfileInfo: BasicProfileInfoViewModelType
    
    var completedCourses: Observable<[CourseCollectionViewCellViewModelType]>
    
    required init(profile: Profile) {
        basicProfileInfo = BasicProfileInfoViewModel(profile: profile)
        completedCourses = profile.rx.completedCourses
            .map {
                Array($0.map { CourseCollectionViewCellViewModel(course: $0) })
                    .sorted { $0.name < $1.name }
            }
        
        let openCourseDetail = PublishSubject<CourseDetailViewModelType>()
        selectCourseDetail = openCourseDetail.asObserver()
        self.openCourseDetail = openCourseDetail.asObservable()
    }
    
}

