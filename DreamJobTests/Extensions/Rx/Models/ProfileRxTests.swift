//
//  ProfileRxTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
import Nimble
@testable import DreamJob

class ProfileRxTests: XCTestCase {
    
    var sut: Profile!
    var dataStack: DataStack!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        dataStack = DataStack()
        sut = dataStack.createObject(ofType: Profile.self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataStack.deleteObject(sut)
    }

    func testUpdateEmail() throws {
        let observer = scheduler.createObserver(String?.self)
        sut.rx.email
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        sut.email = "tung@metropolia.fi"
        expect(try self.sut.rx.email.toBlocking().first()) == "tung@metropolia.fi"
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }
    
    func testUpdateFirstName() throws {
        let observer = scheduler.createObserver(String?.self)
        sut.rx.firstName
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        sut.firstName = "Tung"
        expect(try self.sut.rx.firstName.toBlocking().first()) == "Tung"
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }
    
    func testUpdateLastName() throws {
        let observer = scheduler.createObserver(String?.self)
        sut.rx.lastName
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        sut.lastName = "Vo"
        expect(try self.sut.rx.lastName.toBlocking().first()) == "Vo"
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }
    
    func testUpdateAddress() throws {
        let observer = scheduler.createObserver(String?.self)
        sut.rx.address
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        sut.address = "Helsinki"
        expect(try self.sut.rx.address.toBlocking().first()) == "Helsinki"
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }
    
    func testUpdateStudentId() throws {
        let observer = scheduler.createObserver(String?.self)
        sut.rx.id
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        sut.id = "12234543"
        expect(try self.sut.rx.id.toBlocking().first()) == "12234543"
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }
    
    func testUpdateSocialSecurityNumber() throws {
        let observer = scheduler.createObserver(String?.self)
        sut.rx.socialSecurityNumber
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        sut.socialSecurityNumber = "090909-2355"
        expect(try self.sut.rx.socialSecurityNumber.toBlocking().first()) == "090909-2355"
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }
    
    func testUpdateBirthdate() throws {
        let observer = scheduler.createObserver(Date?.self)
        sut.rx.dateOfBirth
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        let date = Date()
        sut.dateOfBirth = date
        expect(try self.sut.rx.dateOfBirth.toBlocking().first()) == date
        
        // First startWith + the update = 2
        expect(observer.events.count) == 2
    }

}
