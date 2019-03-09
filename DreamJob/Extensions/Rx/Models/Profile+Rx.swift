//
//  Profile+Rx.swift
//  DreamJob
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: Profile {
    
    var firstName: Observable<String?> {
        return observe(String.self, #keyPath(Profile.firstName))
            .startWith(base.firstName)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var lastName: Observable<String?> {
        return observe(String.self, #keyPath(Profile.lastName))
            .startWith(base.lastName)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var address: Observable<String?> {
        return observe(String.self, #keyPath(Profile.address))
            .startWith(base.address)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var id: Observable<String?> {
        return observe(String.self, #keyPath(Profile.id))
            .startWith(base.id)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var email: Observable<String?> {
        return observe(String.self, #keyPath(Profile.email))
            .startWith(base.email)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var socialSecurityNumber: Observable<String?> {
        return observe(String.self, #keyPath(Profile.socialSecurityNumber))
            .startWith(base.socialSecurityNumber)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var dateOfBirth: Observable<Date?> {
        return observe(Date.self, #keyPath(Profile.dateOfBirth))
            .startWith(base.dateOfBirth)
            .distinctUntilChanged()
            .share(replay: 1)
    }
    
    var completedCourses: Observable<Set<Course>> {
        return observe(NSSet.self, #keyPath(Profile.completedCourses))
            .map {_ in self.base.completedCourses?.asSet(type: Course.self) ?? Set<Course>() }
            .startWith(base.completedCourses?.asSet(type: Course.self) ?? Set<Course>())
            .share(replay: 1)
    }
    
    var acquiredSkills: Observable<Set<Skill>> {
        return observe(NSSet.self, #keyPath(Profile.completedCourses))
            .map { [weak base] _ in base?.acquiredSkills ?? Set<Skill>() }
            .startWith(base.acquiredSkills)
            .share(replay: 1)
    }
    
    func didCompleteCourse(_ course: Course) -> Observable<Bool> {
        return observe(NSSet.self, #keyPath(Profile.completedCourses))
            .map { _ in self.base.didCompleteCourse(course) }
            .startWith(self.base.didCompleteCourse(course))
            .share(replay: 1)
    }
    
}
