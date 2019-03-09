//
//  JobListViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 21/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

private let cellReuseIdentifier = "Cell"

class JobListViewController: UICollectionViewController {
    
    private(set) lazy var viewModel: ProfileJobListViewModelType = {
        let jobs = dataStack.allRecords(ofType: Job.self)
        return ProfileJobListViewModel(profile: profile, jobs: jobs)
    }()
    
    private(set) var profile: Profile
    
    private(set) var dataStack: CoreDataStack
    
    private var disposeBag = DisposeBag()
    
    let sectionDataSource = RxCollectionViewSectionedReloadDataSource<JobListSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! JobListCollectionViewCell
            cell.populate(from: item)
            return cell
    })
    
    init(profile aProfile: Profile, dataStack stack: CoreDataStack) {
        dataStack = stack
        profile = aProfile
        super.init(nibName: "JobListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.register(UINib(nibName: "JobListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        title = "Jobs"

        // Do any additional setup after loading the view.
        setUpBindings(viewModel: viewModel)
    }
    
    private func setUpBindings(viewModel: ProfileJobListViewModelType) {
        collectionView.dataSource = nil
        
        Observable.from(optional: viewModel.jobs)
            .map { $0.map { viewModel.profileJobListCollectionViewCellViewModel(for: $0) }}
            .map { JobListSection(items: $0) }
            .map { [$0] }
            .bind(to: collectionView.rx.items(dataSource: sectionDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ProfileJobListCollectionViewCellViewModelType.self)
            .map { JobDetailViewModel(acquiredSkills: viewModel.profile.rx.acquiredSkills, job: $0.job) }
            .bind(to: viewModel.selectJob)
            .disposed(by: disposeBag)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension JobListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
