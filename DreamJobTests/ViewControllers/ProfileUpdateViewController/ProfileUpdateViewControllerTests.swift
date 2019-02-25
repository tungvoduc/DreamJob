//
//  ProfileUpdateViewControllerTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import XCTest
import Nimble
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
@testable import DreamJob

class ProfileUpdateViewControllerTests: XCTestCase {
    
    var viewModel: ProfileUpdateViewModel!
    var sut: ProfileUpdateViewController!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ProfileUpdateViewModel()
        sut = ProfileUpdateViewController(viewModel: viewModel)
        _ = sut.view
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmailTextFieldUpdateReflectsInObservable() throws {
        let observable = viewModel.email
        
        emitNextTextEvent(for: sut.emailTextField, with: "tung.vo@metropolia.fi")
        expect(try observable.toBlocking().first()) == "tung.vo@metropolia.fi"
        
        emitNextTextEvent(for: sut.emailTextField, with: "tung.vo@metropolia.fi")
        expect(try observable.toBlocking().first()) == "tung.vo@metropolia.fi"
    }
    
    func testStudentIdTextFieldUpdateReflectsInObservable() {
        let observable = viewModel.studentId
        
        emitNextTextEvent(for: sut.studentNumberTextField, with: "123456789")
        expect(try observable.toBlocking().first()) == "123456789"
        
        emitNextTextEvent(for: sut.studentNumberTextField, with: "34327842")
        expect(try observable.toBlocking().first()) == "34327842"
    }
    
    func testAddressTextFieldUpdateReflectsInObservable() {
        let observable = viewModel.address
        
        emitNextTextEvent(for: sut.addressTextField, with: "Helsinki, Finland")
        expect(try observable.toBlocking().first()) == "Helsinki, Finland"
        
        emitNextTextEvent(for: sut.addressTextField, with: "Stockholm, Sweden")
        expect(try observable.toBlocking().first()) == "Stockholm, Sweden"
    }
    
    func testLastNameTextFieldUpdateReflectsInObservable() {
        let observable = viewModel.lastName
        
        emitNextTextEvent(for: sut.lastNameTextField, with: "Aguero")
        expect(try observable.toBlocking().first()) == "Aguero"
        
        emitNextTextEvent(for: sut.lastNameTextField, with: "Bruyne")
        expect(try observable.toBlocking().first()) == "Bruyne"
    }
    
    func testFirstNameTextFieldUpdateReflectsInObservable() {
        let observable = viewModel.firstName
        
        emitNextTextEvent(for: sut.firstNameTextField, with: "Kun")
        expect(try observable.toBlocking().first()) == "Kun"
        
        emitNextTextEvent(for: sut.firstNameTextField, with: "Kevin")
        expect(try observable.toBlocking().first()) == "Kevin"
    }
    
    func testSocialNumberTextFieldUpdateReflectsInObservable() {
        let observable = viewModel.socialSecurityNumber
        
        emitNextTextEvent(for: sut.socialNumberTextField, with: "010195-2134")
        expect(try observable.toBlocking().first()) == "010195-2134"
        
        emitNextTextEvent(for: sut.socialNumberTextField, with: "010194-5678")
        expect(try observable.toBlocking().first()) == "010194-5678"
    }
    
    func testUpdatingBirthdateReflectsInUIElement() {
        viewModel.updateBirthdate.onNext(nil)
        expect(self.sut.birthdateTextField.text) == ""
        
        let date = Date().addingTimeInterval(-365 * 3600 * 30)
        viewModel.updateBirthdate.onNext(date)
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        expect(self.sut.birthdateTextField.text) == formatter.string(from: date)
    }
    
    func testSubmitButtonEnability() {
        // First
        expect(self.sut.submitButton.isEnabled) == false
        
        // Have all information
        update(email: "tung@metropolia.fi", studentId: "1236263", firstName: "Tung", lastName: "Vo", socialNumber: "18219298", address: "Espoo, Finland", birthdate: Date())
        expect(self.sut.submitButton.isEnabled) == true
        
        // Missing email
        emitNextTextEvent(for: sut.emailTextField, with: nil)
        expect(self.sut.submitButton.isEnabled) == false
        
        // Missing birthdate
        emitNextTextEvent(for: sut.emailTextField, with: "tung@metropolia.fi")
        viewModel.updateBirthdate.onNext(nil)
        expect(self.sut.submitButton.isEnabled) == false
        
        // Have all information
        viewModel.updateBirthdate.onNext(Date())
        expect(self.sut.submitButton.isEnabled) == true
        
        // Missing student id
        emitNextTextEvent(for: sut.studentNumberTextField, with: "")
        expect(self.sut.submitButton.isEnabled) == false
        
        // Missing last name
        emitNextTextEvent(for: sut.lastNameTextField, with: "")
        emitNextTextEvent(for: sut.studentNumberTextField, with: "12345")
        expect(self.sut.submitButton.isEnabled) == false
    }
    
    func testTappingSubmitButton() {
        let observer = scheduler.createObserver(Profile.self)
        
        viewModel.didSetNewProfile
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        // Fill all information
        update(email: "tung@metropolia.fi", studentId: "1236263", firstName: "Tung", lastName: "Vo", socialNumber: "18219298", address: "Espoo, Finland", birthdate: Date())
        
        expect(observer.events.count) == 0
        
        // Trigger button tapped
        sut.submitButton.sendActions(for: UIControl.Event.touchUpInside)
        sut.submitButton.sendActions(for: UIControl.Event.touchUpInside)
        
        expect(observer.events.count) == 2
        
        // Missing email
        emitNextTextEvent(for: sut.emailTextField, with: nil)
        
        sut.submitButton.sendActions(for: UIControl.Event.touchUpInside)
        expect(observer.events.count) == 2 // Event count stays same as it does not set new profile
    }
    
    func testTappingSubmitButtonCreateNewProfile() {
        let observer = scheduler.createObserver(Profile.self)
        
        viewModel.didSetNewProfile
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        // Fill all information
        update(email: "tung@metropolia.fi", studentId: "1236263", firstName: "Tung", lastName: "Vo", socialNumber: "18219298", address: "Espoo, Finland", birthdate: Date())
        
        scheduler.createColdObservable([
                Recorded.next(10, ()),
                Recorded.next(20, ()),
                Recorded.next(30, ())])
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        expect(observer.events.count) == 3
    }
    
    private func emitNextTextEvent(for textField: UITextField, with value: String?) {
        textField.text = value
        textField.sendActions(for: .valueChanged)
    }
    
    private func update(email: String?, studentId: String?, firstName: String?, lastName: String?, socialNumber: String?, address: String?, birthdate: Date?) {
        emitNextTextEvent(for: sut.emailTextField, with: email)
        emitNextTextEvent(for: sut.addressTextField, with: address)
        emitNextTextEvent(for: sut.firstNameTextField, with: firstName)
        emitNextTextEvent(for: sut.lastNameTextField, with: lastName)
        emitNextTextEvent(for: sut.socialNumberTextField, with: socialNumber)
        emitNextTextEvent(for: sut.studentNumberTextField, with: studentId)
        viewModel.updateBirthdate.onNext(birthdate)
    }

}
