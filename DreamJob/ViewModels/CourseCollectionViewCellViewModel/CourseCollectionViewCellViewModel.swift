//
//  CourseCollectionViewCellViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

protocol CourseBasedViewModelType {
    var course: Course { get }
}

protocol CourseCollectionViewCellViewModelType: CourseBasedViewModelType {
    var name: String { get }
    var creditNumberString: String { get }
    var skillString: String { get }
}

struct CourseCollectionViewCellViewModel: CourseCollectionViewCellViewModelType, Equatable {
    
    var name: String
    
    var creditNumberString: String
    
    var skillString: String
    
    let course: Course
    
    init(course: Course) {
        self.course = course
        
        name = course.name ?? ""
        
        if course.credits == 1 {
            creditNumberString = "1 ECTS credit"
        } else {
            creditNumberString = "\(course.credits) ECTS credits"
        }
        
        let skillsPrefix = "Skills: "
        if let unsortedSkills = course.skills?.allObjects as? [Skill], !unsortedSkills.isEmpty {
            let skills = unsortedSkills.sorted(by: { ($0.name ?? "") <= ($1.name ?? "")}) // Sorted by name
            
            if skills.count <= 2 {
                skillString = skillsPrefix + "\(skills.compactMap { $0.name }.filter { !$0.isEmpty}.joined(separator: ", "))"
            } else {
                let firstTwoSkills = skills.compactMap { $0.name }.filter { !$0.isEmpty}.prefix(upTo: 2)
                let firstTwoSkillsString = firstTwoSkills.joined(separator: ", ")
                let remainingSkillsCount = skills.count - firstTwoSkills.count
                let remainingString: String
                
                if remainingSkillsCount < 2 {
                    remainingString = "\(remainingSkillsCount) other skill"
                } else {
                    remainingString = "\(remainingSkillsCount) other skills"
                }
                
                skillString = skillsPrefix + "\(firstTwoSkillsString) and \(remainingString)"
            }
        } else {
            skillString = skillsPrefix + "Not available"
        }
    }

}


