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
    private var viewModel: ProfileViewModelStub!
    private var sut: ProfileViewController!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        dataStack = DataStack.shared
        profile = dataStack.createObject(ofType: Profile.self)
        viewModel = ProfileViewModelStub(profile: profile)
        sut = ProfileViewController(viewModel: viewModel)
        _ = sut.view // load view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataStack.deleteObject(profile)
    }

    // Test navigation title
    func testsViewControllerTitle() {
        expect(self.sut.title) == "Profile"
    }
    
    // Test populate data correctly
    func testCollectionViewHasCorrectNumberOfItems() {
        var courses = [FakeCourseCollectionViewCellViewModel(), FakeCourseCollectionViewCellViewModel()]
        viewModel.updateCompleteCourses(courses)
        expect(self.sut.collectionView.numberOfItems(inSection: 0)) == 2
        
        courses = [FakeCourseCollectionViewCellViewModel(), FakeCourseCollectionViewCellViewModel(), FakeCourseCollectionViewCellViewModel(), FakeCourseCollectionViewCellViewModel(), FakeCourseCollectionViewCellViewModel()]
        viewModel.updateCompleteCourses(courses)
        expect(self.sut.collectionView.numberOfItems(inSection: 0)) == 5
    }
    
    // Test correct supplementary view
    func testCollectionViewUsesCorrectHeaderViewType() {
        let courses = [FakeCourseCollectionViewCellViewModel()]
        viewModel.updateCompleteCourses(courses)
        expect(self.sut.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) is BasicProfileInfoCollectionReusableView).to(beTrue())
    }
    
    // Test correct UICollectionViewCell class
    func testCollectionViewUsesCorrectCellType() {
        let courses = [FakeCourseCollectionViewCellViewModel(), FakeCourseCollectionViewCellViewModel()]
        viewModel.updateCompleteCourses(courses)
        expect(self.sut.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) is CourseCollectionViewCell).to(beTrue())
    }

}

class ProfileViewModelStub: ProfileViewModelType {
    
    var basicProfileInfo: BasicProfileInfoViewModelType
    
    var completedCourses: Observable<[CourseCollectionViewCellViewModelType]>
    
    var selectCourseDetail: AnyObserver<CourseDetailViewModelType>
    
    var openCourseDetail: Observable<CourseDetailViewModelType>
    
    var profile: Profile
    
    private var completedCoursesObserver: AnyObserver<[CourseCollectionViewCellViewModelType]>
    
    required init(profile: Profile) {
        self.profile = profile
        basicProfileInfo = MockBasicProfileInfoViewModel(profile: profile)
        let completedCourses = PublishSubject<[CourseCollectionViewCellViewModelType]>()
        self.completedCourses = completedCourses.asObservable()
        completedCoursesObserver = completedCourses.asObserver()
        let openCourseDetail = PublishSubject<CourseDetailViewModelType>()
        selectCourseDetail = openCourseDetail.asObserver()
        self.openCourseDetail = openCourseDetail.asObservable()
    }
    
    func updateCompleteCourses(_ courses: [CourseCollectionViewCellViewModelType]) {
        completedCoursesObserver.onNext(courses)
    }
}

struct FakeCourseCollectionViewCellViewModel: CourseCollectionViewCellViewModelType {
    
    var name: String = ""
    
    var creditNumberString: String = ""
    
    var skillString: String = ""
    
    var isCompleted: Observable<Bool> = PublishSubject<Bool>()
    
    var course: Course = Course()
    
    
}
