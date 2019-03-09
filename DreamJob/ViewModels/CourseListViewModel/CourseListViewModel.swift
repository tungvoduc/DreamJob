//
//  CourseListViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 08/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

// MARK: CourseListViewModelType
protocol CourseListViewModelType {
    var courses: Observable<[CourseCollectionViewCellViewModelType]> { get }
    var selectCourseDetail: AnyObserver<CourseDetailViewModelType> { get }
    var openCourseDetail: Observable<CourseDetailViewModelType> { get }
}

// MARK: CourseListViewModel
class CourseListViewModel: NSObject, CourseListViewModelType, NSFetchedResultsControllerDelegate {
    
    var selectCourseDetail: AnyObserver<CourseDetailViewModelType>
    
    var openCourseDetail: Observable<CourseDetailViewModelType>
    
    var courses: Observable<[CourseCollectionViewCellViewModelType]>
    
    var coursesSubject: ReplaySubject<[CourseCollectionViewCellViewModelType]>
    
    private let fetchedCoursesController: NSFetchedResultsController<Course>
    
    private let disposeBag = DisposeBag()
    
    init(profile: Profile, dataStack: CoreDataStack = DataStack.shared) {
        
        coursesSubject = ReplaySubject<[CourseCollectionViewCellViewModelType]>.create(bufferSize: 1)
        
        let openCourseDetail = PublishSubject<CourseDetailViewModelType>()
        selectCourseDetail = openCourseDetail.asObserver()
        self.openCourseDetail = openCourseDetail.asObservable()
        
        courses = coursesSubject.asObservable()
        
        let completedCourses = profile.rx
            .completedCourses
            .share(replay: 1)
        
        fetchedCoursesController = dataStack.fetchResultController(type: Course.self, predicate: nil, sortDescriptors: [NSSortDescriptor(key: #keyPath(Course.name), ascending: true)], sectionNameKeyPath: nil, cacheName: nil)
        
        
        (fetchedCoursesController as! NSFetchedResultsController<NSFetchRequestResult>)
            .rx
            .didChangeContent
            .map { $0 as! NSFetchedResultsController<Course> }
            .map { $0.fetchedObjects }
            .flatMap { Observable.from(optional: $0) }
            .map { $0.map { CourseCollectionViewCellViewModel(course: $0, completedCourses: completedCourses) } }
            .bind(to: coursesSubject)
            .disposed(by: disposeBag)
        
        super.init()
//        fetchedCoursesController.delegate = self
        
        do {
            try fetchedCoursesController.performFetch()
        } catch {
            print("Hello")
        }
    }
}
