//
//  CourseListViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 21/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let cellReuseIdentifier = "Cell"

class CourseListViewController: UICollectionViewController {
    
    private(set) var viewModel: CourseListViewModelType
    
    private let disposeBag = DisposeBag()
    
    private var profile: Profile
    
    let sectionDataSource = RxCollectionViewSectionedReloadDataSource<CourseListViewSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CourseCollectionViewCell
            cell.populate(from: item)
            return cell
    })
    
    init(viewModel: CourseListViewModelType, profile: Profile) {
        self.viewModel = viewModel
        self.profile = profile
        super.init(nibName: "CourseListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        title = "Courses"
        
        collectionView!.register(UINib(nibName: "CourseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        collectionView.dataSource = nil
        
        viewModel.courses
            .map { CourseListViewSection(items: $0) }
            .map { [$0] }
            .do(onNext: { courses in
                print(courses.count)
            })
            .bind(to: collectionView.rx.items(dataSource: sectionDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(CourseCollectionViewCellViewModelType.self)
            .map {[unowned self] in CourseDetailViewModel(course: $0.course, profile: self.profile) }
            .bind(to: viewModel.selectCourseDetail)
            .disposed(by: disposeBag)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension CourseListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
