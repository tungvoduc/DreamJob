//
//  BasicProfileInfoViewModelTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

@testable import DreamJob
import XCTest
import RxSwift
import RxCocoa
import Nimble
import RxTest
import RxBlocking

class BasicProfileInfoViewModelTests: XCTestCase {
    
    var sut: BasicProfileInfoViewModel!
    var profile: Profile!
    var dataStack: DataStack!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    
    private var testSkills: [Skill]!
    private var testCourses: [Course]!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        dataStack = DataStack()
        profile = dataStack.createObject(ofType: Profile.self)
        sut = BasicProfileInfoViewModel(profile: profile)
        
        // Test
        testSkills = []
        testCourses = []
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataStack.deleteObject(profile)
        dataStack.deleteObjects(testSkills)
        dataStack.deleteObjects(testCourses)
    }

    // Test observable works correctly whenever first name or last name changes
    func testUpdatingFullname() throws {
        let observer = scheduler.createObserver(String.self)
        
        sut.fullName
            .drive(observer)
            .disposed(by: disposeBag)
        
        expect(observer.events.count) == 1
        expect(try self.sut.fullName.toBlocking().first()) == ""
        
        profile.firstName = "Tung" // 2
        expect(observer.events.count) == 2
        expect(try self.sut.fullName.toBlocking().first()) == "Tung"
        
        profile.lastName = "Vo" // 3
        expect(observer.events.count) == 3
        expect(try self.sut.fullName.toBlocking().first()) == "Tung Vo"
        
        profile.firstName = "Tung" // 3
        expect(observer.events.count) == 3
        expect(try self.sut.fullName.toBlocking().first()) == "Tung Vo"
        
        profile.lastName = "Nguyen" // 4
        expect(observer.events.count) == 4
        expect(try self.sut.fullName.toBlocking().first()) == "Tung Nguyen"
    }
    
    // Test observable works correctly whenever student number changes
    func testUpdatingStudentNumber() {
        let observer = scheduler.createObserver(String.self)
        
        sut.studentNumber
            .drive(observer)
            .disposed(by: disposeBag)
        
        expect(observer.events.count) == 1
        expect(try self.sut.studentNumber.toBlocking().first()) == ""
        
        profile.id = "123456"
        expect(observer.events.count) == 2
        expect(try self.sut.studentNumber.toBlocking().first()) == "123456"
        
        profile.id = "123456"
        expect(observer.events.count) == 2
    }
    
    // Test observable works correctly whenever email changes
    func testUpdatingEmail() {
        let observer = scheduler.createObserver(String.self)
        
        sut.email
            .drive(observer)
            .disposed(by: disposeBag)
        
        expect(observer.events.count) == 1
        expect(try self.sut.email.toBlocking().first()) == ""
        
        profile.email = "tung@example.com"
        expect(observer.events.count) == 2
        expect(try self.sut.email.toBlocking().first()) == "tung@example.com"
        
        profile.email = "tung@example.com"
        expect(observer.events.count) == 2
    }
    
    // Test total number of credits observable works correctly when adding new completed course to profile
    func testUpdatingTotalCredits() {
        expect(try self.sut.totalCredits.toBlocking().first()) == 0
        
        // Add course
        let course = addCourseToProfile(code: "AABBCC", numberOfCredits: 5, name: "Programming")
        expect(try self.sut.totalCredits.toBlocking().first()) == 5
        
        // Add course
        addCourseToProfile(code: "XYZZZZZ", numberOfCredits: 10, name: "C++")
        expect(try self.sut.totalCredits.toBlocking().first()) == 15
        
        profile.removeFromCompletedCourses(course)
        expect(try self.sut.totalCredits.toBlocking().first()) == 10
    }
    
    // Test total number of skills observable works correctly when adding new completed course to profile
    func testUpdatingTotalSkills() {
        expect(try self.sut.totalSKills.toBlocking().first()) == 0
        
        // Add course
        let course1 = createTestCourse(code: "AAAA", numberOfCredits: 5, name: "Programming 1")
        let skill1 = createTestSkill(name: "Skill 1")
        let skill2 = createTestSkill(name: "Skill 2")
        let skill3 = createTestSkill(name: "Skill 3")
        course1.addToSkills(skill1)
        course1.addToSkills(skill2)
        course1.addToSkills(skill3)
        
        let course2 = createTestCourse(code: "BBBB", numberOfCredits: 3, name: "Programming 2")
        let skill4 = createTestSkill(name: "Skill 4")
        course2.addToSkills(skill1)
        course2.addToSkills(skill4)
        
        let course3 = createTestCourse(code: "CCCC", numberOfCredits: 10, name: "Programming 3")
        let skill5 = createTestSkill(name: "Skill 5")
        let skill6 = createTestSkill(name: "Skill 6")
        course3.addToSkills(skill5)
        course3.addToSkills(skill6)
        course3.addToSkills(skill2)
        
        // Add course
        profile.addToCompletedCourses(course1)
        expect(try self.sut.totalSKills.toBlocking().first()) == 3
        
        profile.addToCompletedCourses(course2)
        expect(try self.sut.totalSKills.toBlocking().first()) == 4
        
        profile.addToCompletedCourses(course3)
        expect(try self.sut.totalSKills.toBlocking().first()) == 6
        
        profile.removeFromCompletedCourses(course2)
        expect(try self.sut.totalSKills.toBlocking().first()) == 5
    }
    
    // Helper methods
    private func createTestSkill(name: String) -> Skill {
        let skill = dataStack.createSkill(id: UUID().uuidString, name: name)
        testSkills.append(skill)
        return skill
    }
    
    private func createTestCourse(code: String, numberOfCredits: Int16, name: String) -> Course {
        let course = dataStack.createCourse(id: UUID().uuidString, code: code, numberOfCredits: numberOfCredits, name: name)
        testCourses.append(course)
        return course
    }
    
    @discardableResult
    private func addCourseToProfile(code: String, numberOfCredits: Int16, name: String) -> Course {
        let course = createTestCourse(code: code, numberOfCredits: numberOfCredits, name: name)
        profile.addToCompletedCourses(course)
        return course
    }

}
