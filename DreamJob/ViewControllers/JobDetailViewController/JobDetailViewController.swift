//
//  JobDetailViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 21/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift

class JobDetailViewController: UIViewController {
    
    let viewModel: JobDetailViewModelType
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var requiredSkillsLabel: UILabel!
    @IBOutlet weak var alreadyHaveSkillsLabel: UILabel!
    @IBOutlet weak var missingSkillsLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    init(viewModel model: JobDetailViewModelType) {
        viewModel = model
        super.init(nibName: "JobDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpBindings()
    }

    private func setUpBindings() {
        nameLabel.attributedText = viewModel.name
        requiredSkillsLabel.attributedText = viewModel.totalSkillsString
        jobDescriptionLabel.attributedText = viewModel.jobDescription
        
        viewModel.acquiredSkillsString.subscribe(onNext: { [unowned self] string in
            self.alreadyHaveSkillsLabel.attributedText = string
        })
            .disposed(by: disposeBag)
        
        viewModel.missingSkillsString.subscribe(onNext: { [unowned self] string in
            self.missingSkillsLabel.attributedText = string
        })
            .disposed(by: disposeBag)
    }

}
