//
//  CourseDetailViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift

class CourseDetailViewController: UIViewController {
    @IBOutlet weak var creditNumberLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prerequisitesLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    private(set) var viewModel: CourseDetailViewModelType!
    
    private let disposeBag = DisposeBag()
    
    init(viewModel model: CourseDetailViewModelType) {
        viewModel = model
        super.init(nibName: "CourseDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = 5
        actionButton.layer.masksToBounds = true
        actionButton.setTitle("Add course to profile", for: .normal)
        actionButton.setTitle("Remove course from profile", for: .selected)
        actionButton.setTitleColor(UIColor.white, for: [])
        actionButton.setBackgroundImage(UIImage.imageWithColor(UIColor.blue, size: CGSize(width: 1, height: 1)), for: .normal)
        actionButton.setBackgroundImage(UIImage.imageWithColor(UIColor.red, size: CGSize(width: 1, height: 1)), for: .selected)

        // Do any additional setup after loading the view.
        populateData()
    }
    
    private func populateData() {
        title = viewModel.name
        creditNumberLabel.text = viewModel.creditNumberString
        skillsLabel.text = viewModel.skillString
        descriptionLabel.text = viewModel.courseDescription
        prerequisitesLabel.text = viewModel.prerequisitesString
        
        viewModel.didCompleteCourse
            .do(onNext: { completed in
                print(completed)
            })
            .bind(to: actionButton.rx.isSelected)
            .disposed(by: disposeBag)
    }

    @IBAction func acitonButtonTapped(_ sender: Any) {
        if actionButton.isSelected {
            viewModel.removeCourse.onNext(())
        } else {
            viewModel.addCourse.onNext(())
        }
    }
}
