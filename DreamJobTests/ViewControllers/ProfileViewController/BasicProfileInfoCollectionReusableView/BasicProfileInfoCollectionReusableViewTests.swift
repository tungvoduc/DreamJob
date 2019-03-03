//
//  BasicProfileInfoCollectionReusableViewTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 02/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import XCTest
import Nimble
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
@testable import DreamJob

// MARK: BasicProfileInfoCollectionReusableViewTests
class BasicProfileInfoCollectionReusableViewTests: XCTestCase {
    
    var sut: BasicProfileInfoCollectionReusableView!
    var viewModel: MockBasicProfileInfoViewModel!
    let nib = UINib(nibName: "BasicProfileInfoCollectionReusableView", bundle: Bundle(for: BasicProfileInfoCollectionReusableView.self))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let view = nib.instantiate(withOwner: nil, options: nil).first as? BasicProfileInfoCollectionReusableView {
            sut = view
        } else {
            fatalError("Cannot load BasicProfileInfoCollectionReusableView from nib")
        }
        
        viewModel = MockBasicProfileInfoViewModel(profile: Profile())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Updating full name label whenever observable emits new values.
    func testUpdatingFullNameFromViewModel() {
        sut.populate(from: viewModel)
        expect(self.sut.fullNameLabel.text) == ""
        
        viewModel.fullNamePublishSubject.onNext("Tung Vo")
        expect(self.sut.fullNameLabel.text) == "Tung Vo"
        
        viewModel.fullNamePublishSubject.onNext("Tung Vo Duc")
        expect(self.sut.fullNameLabel.text) == "Tung Vo Duc"
    }
    
    // Updating student number label whenever observable emits new values.
    func testUpdatingStudentNumberFromViewModel() {
        sut.populate(from: viewModel)
        expect(self.sut.studentNumberLabel.text) == ""
        
        viewModel.studentNumberPublishSubject.onNext("1234567")
        expect(self.sut.studentNumberLabel.text) == "1234567"
        
        viewModel.studentNumberPublishSubject.onNext("999999")
        expect(self.sut.studentNumberLabel.text) == "999999"
    }
    
    // Updating email whenever label observable emits new values.
    func testUpdatingEmailFromViewModel() {
        sut.populate(from: viewModel)
        expect(self.sut.emailLabel.text) == ""
        
        viewModel.emailPublishSubject.onNext("tung@example.com")
        expect(self.sut.emailLabel.text) == "tung@example.com"
        
        viewModel.emailPublishSubject.onNext("tung@anotherexample.com")
        expect(self.sut.emailLabel.text) == "tung@anotherexample.com"
    }
    
    // Updating total credits label whenever observable emits new values.
    func testUpdatingTotalCreditsFromViewModel() {
        sut.populate(from: viewModel)
        expect(self.sut.creditNumberLabel.text) == "0 credits"
        
        viewModel.totalCreditsPublishSubject.onNext(1)
        expect(self.sut.creditNumberLabel.text) == "1 credit"
        
        viewModel.totalCreditsPublishSubject.onNext(100)
        expect(self.sut.creditNumberLabel.text) == "100 credits"
        
        viewModel.totalCreditsPublishSubject.onNext(0)
        expect(self.sut.creditNumberLabel.text) == "0 credits"
    }
    
    // Updating total skills label whenever observable emits new values.
    func testUpdatingTotalSkillsFromViewModel() {
        sut.populate(from: viewModel)
        expect(self.sut.skillNumberLabel.text) == "0 skills"
        
        viewModel.totalSKillsPublishSubject.onNext(1)
        expect(self.sut.skillNumberLabel.text) == "1 skill"
        
        viewModel.totalSKillsPublishSubject.onNext(100)
        expect(self.sut.skillNumberLabel.text) == "100 skills"
        
        viewModel.totalSKillsPublishSubject.onNext(0)
        expect(self.sut.skillNumberLabel.text) == "0 skills"
    }

}

// MARK: MockBasicProfileInfoViewModel
class MockBasicProfileInfoViewModel: BasicProfileInfoViewModelType {
    
    var fullName: Driver<String>
    
    var studentNumber: Driver<String>
    
    var email: Driver<String>
    
    var totalCredits: Driver<Int>
    
    var totalSKills: Driver<Int>
    
    // Extra
    var fullNamePublishSubject: PublishSubject<String>

    var studentNumberPublishSubject: PublishSubject<String>

    var emailPublishSubject: PublishSubject<String>

    var totalCreditsPublishSubject: PublishSubject<Int>

    var totalSKillsPublishSubject: PublishSubject<Int>
    
    required init(profile: Profile) {
        fullNamePublishSubject = PublishSubject<String>()
        studentNumberPublishSubject = PublishSubject<String>()
        emailPublishSubject = PublishSubject<String>()
        totalCreditsPublishSubject = PublishSubject<Int>()
        totalSKillsPublishSubject = PublishSubject<Int>()
        
        fullName = fullNamePublishSubject.asDriver(onErrorJustReturn: "")
        studentNumber = studentNumberPublishSubject.asDriver(onErrorJustReturn: "")
        email = emailPublishSubject.asDriver(onErrorJustReturn: "")
        totalCredits = totalCreditsPublishSubject.asDriver(onErrorJustReturn: 0)
        totalSKills = totalSKillsPublishSubject.asDriver(onErrorJustReturn: 0)
    }
}
