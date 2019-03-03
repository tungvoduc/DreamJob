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
}

struct CourseDetailViewModel: CourseDetailViewModelType {
    
    var name: String
    
    var creditNumberString: String
    
    var skillString: String
    
    var courseDescription: String
    
    let course: Course
    
    init(course: Course) {
        self.course = course
        
        name = course.name ?? ""
        
        creditNumberString = "Number of credits: \(course.credits)"
        
        let skillsPrefix = "Skills: "
        if let unsortedSkills = course.skills?.allObjects as? [Skill], !unsortedSkills.isEmpty {
            let skills = unsortedSkills.compactMap{ $0.name }.sorted() // Sorted by name
            skillString = skillsPrefix + skills.joined(separator: ", ")
        } else {
            skillString = skillsPrefix + "Not available"
        }
        
        if let courseDescription = course.courseDescription, !courseDescription.isEmpty {
            self.courseDescription = "Description: \(courseDescription)"
        } else {
            self.courseDescription = "Description: Not available"
        }
        
    }
    
}
