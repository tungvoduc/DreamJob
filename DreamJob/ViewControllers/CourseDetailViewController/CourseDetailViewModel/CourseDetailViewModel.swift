//
//  CourseDetailViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CourseDetailViewModelType: CourseBasedViewModelType {
    var name: String { get }
    var creditNumberString: String { get }
    var skillString: String { get }
    var courseDescription: String { get }
    var prerequisitesString: String { get }
    var didCompleteCourse: Observable<Bool> { get }
    
    var addCourse: AnyObserver<Void> { get }
    var removeCourse: AnyObserver<Void> { get }
}

struct CourseDetailViewModel: CourseDetailViewModelType {
    
    var removeCourse: AnyObserver<Void>
    
    var addCourse: AnyObserver<Void>
    
    var didCompleteCourse: Observable<Bool>
    
    var prerequisitesString: String
    
    var name: String
    
    var creditNumberString: String
    
    var skillString: String
    
    var courseDescription: String
    
    let course: Course
    
    let profile: Profile
    
    private let disposeBag = DisposeBag()
    
    init(course: Course, profile: Profile) {
        self.course = course
        self.profile = profile
        
        name = course.name ?? ""
        
        creditNumberString = "Number of credits: \(course.credits)"
        
        // Skills
        let skillsPrefix = "Skills: "
        if let unsortedSkills = course.skills?.allObjects as? [Skill], !unsortedSkills.isEmpty {
            let skills = unsortedSkills.compactMap{ $0.name }.sorted() // Sorted by name
            skillString = skillsPrefix + skills.joined(separator: ", ")
        } else {
            skillString = skillsPrefix + "Not available"
        }
        
        // Description
        if let courseDescription = course.courseDescription, !courseDescription.isEmpty {
            self.courseDescription = "Description: \(courseDescription)"
        } else {
            self.courseDescription = "Description: Not available"
        }
        
        // Prerequisites
        let prerequisitesPrefix = "Prerequisites: "
        if let unsortedSkills = course.requiredSkills?.allObjects as? [Skill], !unsortedSkills.isEmpty {
            let skills = unsortedSkills.compactMap{ $0.name }.sorted() // Sorted by name
            prerequisitesString = prerequisitesPrefix + skills.joined(separator: ", ")
        } else {
            prerequisitesString = prerequisitesPrefix + "Not available"
        }
        
        didCompleteCourse = profile.rx.didCompleteCourse(course)
        
        let dataStack: CoreDataStack = DataStack.shared
        let addCourse = PublishSubject<Void>()
        self.addCourse = addCourse.asObserver()
        addCourse.asObservable()
            .subscribe(onNext: { _ in
                profile.addToCompletedCourses(course)
                dataStack.saveContext()
            })
            .disposed(by: disposeBag)
        
        let removeCourse = PublishSubject<Void>()
        self.removeCourse = removeCourse.asObserver()
        removeCourse.asObservable()
            .subscribe(onNext: { _ in
                profile.removeFromCompletedCourses(course)
                dataStack.saveContext()
            })
            .disposed(by: disposeBag)
    }
    
}
