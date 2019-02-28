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
    var completedCourses: Observable<[CourseCollectionViewCellViewModel]> { get }
}

// MARK: ProfileViewModel
class ProfileViewModel: ProfileViewModelType {
    
    var basicProfileInfo: BasicProfileInfoViewModelType
    
    var completedCourses: Observable<[CourseCollectionViewCellViewModel]>
    
    required init(profile: Profile) {
        basicProfileInfo = BasicProfileInfoViewModel(profile: profile)
        completedCourses = profile.rx.completedCourses
            .map {
                Array($0.map { CourseCollectionViewCellViewModel(course: $0) })
                    .sorted { $0.name < $1.name }
            }
    }
    
}

