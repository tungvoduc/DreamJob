//
//  AppCoordinatorTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 22/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import XCTest
import Nimble
@testable import DreamJob

class AppCoordinatorTests: XCTestCase {
    
    var sut: AppCoordinator!
    var router: RouterType!
    var profileManager: MockProfileManager!
    var window: UIWindow!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        profileManager = MockProfileManager()
        window = UIWindow()
        sut = AppCoordinator(window: window, profileManager: profileManager)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPresentableIsContainerController() {
        expect(self.sut.toPresentable()).to(equal(sut.containerController))
    }
    
    func testContainerControllerHasCorrectCurrentViewController() {
        profileManager.profile = nil
        expect(self.sut.currentViewController() is ProfileUpdateViewController).to(equal(true))
        
        profileManager.profile = Profile()
        expect(self.sut.currentViewController() is ProfileViewController).to(equal(true))
    }
    
    func testSettingNewProfileThroughProfileManager() {
        sut.setProfile(with: "", studentId: "", firstName: "", lastName: "", socialSecurityNumber: "", dateOfBirth: Date(), address: "")
        expect(self.profileManager.didSetNewProfile).to(beTrue())
    }

    func testWindowRootViewController() {
        expect(self.window.rootViewController).to(equal(sut.containerController))
    }
    
    func testUpdatingNewProfileWillChangeContainerCurrentViewController() {
        profileManager.profile = nil
        expect(self.sut.containerController.currentViewController is ProfileUpdateViewController).to(equal(true))
        
        sut.setProfile(with: "", studentId: "", firstName: "", lastName: "", socialSecurityNumber: "", dateOfBirth: Date(), address: "")
        expect(self.sut.containerController.currentViewController is ProfileViewController).to(equal(true))
    }

}
