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
        DataStack().deleteAllRecords(ofType: Profile.self)
        profileManager = MockProfileManager()
        window = UIWindow()
        sut = AppCoordinator(window: window, profileManager: profileManager)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DataStack().deleteAllRecords(ofType: Profile.self)
    }

    func testPresentableIsContainerController() {
        expect(self.sut.toPresentable()).to(equal(sut.containerController))
    }
    
    func testHavingCorrectCurrentCoordinator() {
        profileManager.profile = nil
        expect(self.sut.currentCoordinator() is ProfileUpdateCoordinator).to(beTrue())
        
        profileManager.profile = DataStack().createObject(ofType: Profile.self)
        expect(self.sut.currentCoordinator() is ProfileCoordinator).to(beTrue())
    }

    func testWindowRootViewController() {
        expect(self.window.rootViewController).to(equal(sut.containerController))
    }
    
    // Test child coordinator is correctly updated
    func testUpdatingChildCoordinator() {
        expect(self.sut.childCoordinator is ProfileUpdateCoordinator).to(beTrue())
        
        let profile = DataStack().createObject(ofType: Profile.self)
        let newCoordinator = ProfileCoordinator(viewModel: ProfileViewModel(profile: profile))
        sut.show(newCoordinator, animated: false, completion: nil)
        expect(self.sut.childCoordinator is ProfileCoordinator).to(beTrue())
    }

}
