//
//  BasicProfileInfoViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 25/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BasicProfileInfoViewModelType {
    var fullName: Driver<String> { get }
    var studentNumber: Driver<String> { get }
    var email: Driver<String> { get }
    var totalCredits: Driver<Int> { get }
    var totalSKills: Driver<Int> { get }
}

class BasicProfileInfoViewModel: BasicProfileInfoViewModelType {
    
    var fullName: Driver<String>
    
    var studentNumber: Driver<String>
    
    var email: Driver<String>
    
    var totalCredits: Driver<Int>
    
    var totalSKills: Driver<Int>
    
    required init(profile: Profile) {
        email = profile.rx.email
            .asDriver(onErrorJustReturn: nil)
            .map { $0 ?? "" }
        
        studentNumber = profile.rx.id
            .asDriver(onErrorJustReturn: nil)
            .map { $0 ?? "" }
        
        fullName = Observable.combineLatest(profile.rx.firstName, profile.rx.lastName, resultSelector: { (firstName, lastName) -> String in
            if let firstName = firstName {
                if let lastName = lastName {
                    return firstName + " " + lastName
                }
                return firstName
            }
            
            return lastName ?? ""
        })
        .asDriver(onErrorJustReturn: "")
        
        totalCredits = profile.rx.completedCourses
            .map { $0.reduce(0, { (current, course) -> Int in
                return current + Int(course.credits)
            })}
            .asDriver(onErrorJustReturn: 0)
        
        totalSKills = profile.rx.completedCourses
            .map { $0.reduce(Set<Skill>(), { (set, course) -> Set<Skill> in
                var currentSkilss = set
                if let skills = course.skills as? Set<Skill> {
                    for skill in skills.filter({ !set.contains($0) }) {
                        currentSkilss.insert(skill)
                    }
                }
                
                return currentSkilss
            })}
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
    }
    
}
