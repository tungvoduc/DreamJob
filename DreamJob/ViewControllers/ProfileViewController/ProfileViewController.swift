//
//  ProfileViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 01/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let cellReuseIdentifier = "Cell"
private let headerReuseIdentifier = "Header"

class ProfileViewController: UICollectionViewController {
    
    private(set) var viewModel: ProfileViewModelType
    
    private let disposeBag = DisposeBag()
    
    let sectionDataSource = RxCollectionViewSectionedReloadDataSource<ProfileViewSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CourseCollectionViewCell
            cell.populate(from: item)
            return cell
    })
    
    init(viewModel: ProfileViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "ProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.register(UINib(nibName: "CourseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView!.register(UINib(nibName: "BasicProfileInfoCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)

        // Do any additional setup after loading the view.
        title = "Profile"
        setUpBindings()
    }
    
    private func setUpBindings() {
        collectionView.dataSource = nil
        
        sectionDataSource.configureSupplementaryView = {[unowned self](dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! BasicProfileInfoCollectionReusableView
            headerView.populate(from: self.viewModel.basicProfileInfo)
            return headerView
        }
        
        viewModel.completedCourses
            .map { ProfileViewSection(items: $0) }
            .map { [$0] }
            .bind(to: collectionView.rx.items(dataSource: sectionDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(CourseCollectionViewCellViewModelType.self)
            .map { CourseDetailViewModel(course: $0.course) }
            .bind(to: viewModel.selectCourseDetail)
            .disposed(by: disposeBag)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
