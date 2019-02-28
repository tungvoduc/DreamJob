//
//  CourseCollectionViewCellViewModelTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

@testable import DreamJob
import XCTest
import Nimble

class CourseCollectionViewCellViewModelTests: XCTestCase {

    var course: Course!
    var dataStack: DataStack!
    
    private var testSkills: [Skill]!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataStack = DataStack()
        course = dataStack.createObject(ofType: Course.self)
        testSkills = []
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataStack.deleteObject(course)
        dataStack.deleteObjects(testSkills)
    }

    func testCourseName() {
        course.name = "Hello world!"
        let viewModel = CourseCollectionViewCellViewModel(course: course)
        
        expect(viewModel.name) == "Hello world!"
    }
    
    func testSkillString() {
        let skill1 = createTestSkill(name: "Skill 1")
        let skill2 = createTestSkill(name: "Skill 2")
        let skill3 = createTestSkill(name: "Skill 3")
        let skill4 = createTestSkill(name: "Skill 4")
        let skill5 = createTestSkill(name: "Skill 5")
        
         var viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.skillString) == "Skills: Not available"
        
        course.addToSkills(skill1)
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.skillString) == "Skills: Skill 1"
        
        course.addToSkills(skill5)
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.skillString) == "Skills: Skill 1, Skill 5"
        
        course.addToSkills(skill3)
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.skillString) == "Skills: Skill 1, Skill 3 and 1 other skill"
        
        course.addToSkills(skill2)
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.skillString) == "Skills: Skill 1, Skill 2 and 2 other skills"
        
        course.addToSkills(skill4)
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.skillString) == "Skills: Skill 1, Skill 2 and 3 other skills"
    }
    
    func testCreditNumberString() {
        course.credits = 1
        var viewModel = CourseCollectionViewCellViewModel(course: course)
        
        expect(viewModel.creditNumberString) == "1 ECTS credit"
        
        course.credits = 5
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.creditNumberString) == "5 ECTS credits"
        
        course.credits = 0
        viewModel = CourseCollectionViewCellViewModel(course: course)
        expect(viewModel.creditNumberString) == "0 ECTS credits"
    }
    
    // Helper methods
    private func createTestSkill(name: String) -> Skill {
        let skill = dataStack.createSkill(id: UUID().uuidString, name: name)
        testSkills.append(skill)
        return skill
    }

}
