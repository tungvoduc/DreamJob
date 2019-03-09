//
//  Profile+Extensions.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

extension Profile {
    
    // Return unique skills acquired by current profile
    var acquiredSkills: Set<Skill> {
        if let skills = (completedCourses as? Set<Course>)?.compactMap({ $0.skills as? Set<Skill> }).reduce(Set<Skill>(), { (current, skills) -> Set<Skill> in
            var set = current
            for skill in skills {
                if !set.contains(where: { $0.hasSamePrimaryKey(with: skill) }) {
                    set.insert(skill)
                }
            }
            return set
        }) {
            return skills
        }
    
        return Set<Skill>()
    }
    
    func didCompleteCourse(_ course: Course) -> Bool {
        if let completedCourses = completedCourses?.asSet(type: Course.self) {
            if completedCourses.contains(where: { $0.hasSamePrimaryKey(with: course) }) {
                return true
            }
        }
        
        return false
    }
    
}
