//
//  CourseCollectionViewCellTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import XCTest
import Nimble
@testable import DreamJob

class CourseCollectionViewCellTests: XCTestCase {
    
    var sut: CourseCollectionViewCell!
    private let nib = UINib(nibName: "CourseCollectionViewCell", bundle: Bundle(for: CourseCollectionViewCell.self))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let cell = nib.instantiate(withOwner: nil, options: nil).first as? CourseCollectionViewCell {
            sut = cell
        } else {
            fatalError("Cannot load CourseCollectionViewCell from nib")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test CourseCollectionViewCell's labels before populating data
    func testTextLabelsBeforePopulatingData() {
        testLabelText(withName: "", creditsString: "", skillsString: "")
    }
    
    // Test CourseCollectionViewCell populating data correctly
    func testPopulatingDataCorrectly() {
        let model = MockCourseBasedViewModel(name: "Course 1", creditNumberString: "5 credits", skillString: "Too many skills")
        sut.populate(from: model)
        testLabelText(withName: "Course 1", creditsString: "5 credits", skillsString: "Too many skills")
    }
    
    func testLabelText(withName name: String?, creditsString: String?, skillsString: String?) {
        expect(self.sut.nameLabel.text) == name
        expect(self.sut.creditNumberLabel.text) == creditsString
        expect(self.sut.skillsLabel.text) == skillsString
    }

}

// MARK: MockCourseBasedViewModel
struct MockCourseBasedViewModel: CourseCollectionViewCellViewModelType {
    
    var name: String = ""
    
    var creditNumberString: String = ""
    
    var skillString: String = ""
    
    init(course: Course) {
        
    }
    
    init(name: String, creditNumberString: String, skillString: String) {
        self.name = name
        self.creditNumberString = creditNumberString
        self.skillString = skillString
    }
    
}
