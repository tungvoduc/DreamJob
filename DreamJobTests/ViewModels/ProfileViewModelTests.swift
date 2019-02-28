//
//  ProfileViewModelTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 01/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

@testable import DreamJob
import XCTest
import RxSwift
import RxCocoa
import Nimble
import RxTest
import RxBlocking

class ProfileViewModelTests: XCTestCase {
    
    var sut: ProfileViewModel!
    var profile: Profile!
    var dataStack: DataStack!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataStack = DataStack()
        profile = dataStack.createObject(ofType: Profile.self)
        sut = ProfileViewModel(profile: profile)
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Test completedCourses are properly updated after profile's completedCourses is updated
    func testUpdatingCompletedCourses() throws {
        
        var set1 = Set<Course>()
        let course1 = dataStack.createCourse(id: "1234", code: "AAA", numberOfCredits: 5, name: "Course 1")
        let course2 = dataStack.createCourse(id: "2345", code: "BBB", numberOfCredits: 3, name: "Course 2")
        let course3 = dataStack.createCourse(id: "3456", code: "CCC", numberOfCredits: 4, name: "Course 3")
        set1.insert(course1)
        set1.insert(course2)
        set1.insert(course3)
        
        profile.completedCourses = set1 as NSSet
        expect(try self.sut.completedCourses.toBlocking().first()) == [
                CourseCollectionViewCellViewModel(course: course1),
                CourseCollectionViewCellViewModel(course: course2),
                CourseCollectionViewCellViewModel(course: course3)
            ]
        
        let course4 = dataStack.createCourse(id: "2222", code: "DDD", numberOfCredits: 5, name: "Course 4")
        let course5 = dataStack.createCourse(id: "1111", code: "EEE", numberOfCredits: 15, name: "Course 5")
        var set2 = Set<Course>()
        set2.insert(course4)
        set2.insert(course5)
        profile.completedCourses = set2 as NSSet
        expect(try self.sut.completedCourses.toBlocking().first()) == [
            CourseCollectionViewCellViewModel(course: course4),
            CourseCollectionViewCellViewModel(course: course5)
        ]
    }

}
