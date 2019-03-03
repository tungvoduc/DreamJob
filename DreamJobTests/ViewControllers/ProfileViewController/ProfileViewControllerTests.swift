//
//  ProfileViewControllerTests.swift
//  DreamJobTests
//
//  Created by Vo Tung on 01/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import XCTest
import Nimble
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
@testable import DreamJob

class ProfileViewControllerTests: XCTestCase {
    
    private var dataStack: DataStack!
    private var profile: Profile!
    private var viewModel: ProfileViewModelType!
    private var sut: ProfileViewController!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        dataStack = DataStack()
        profile = dataStack.createObject(ofType: Profile.self)
        viewModel = ProfileViewModel(profile: profile)
        sut = ProfileViewController(viewModel: viewModel)
        _ = sut.view // load view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test navigation title
    func testsViewControllerTitle() {
        expect(self.sut.title) == "Profile"
    }
    
    

}
