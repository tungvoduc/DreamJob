//
//  DataStack+Helpers.swift
//  DreamJobTests
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
@testable import DreamJob

extension DataStack {
    
    func createCourse(id: String, code: String, numberOfCredits: Int16, name: String) -> Course {
        let course = createObject(ofType: Course.self)
        course.id = id
        course.code = code
        course.credits = numberOfCredits
        course.name = name
        return course
    }
    
    func createSkill(id: String, name: String) -> Skill {
        let skill = createObject(ofType: Skill.self)
        skill.id = id
        skill.name = name
        return skill
    }
    
}
