//
//  CourseDetailViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
    @IBOutlet weak var creditNumberLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private(set) var viewModel: CourseDetailViewModelType!
    
    init(viewModel model: CourseDetailViewModelType) {
        viewModel = model
        super.init(nibName: "CourseDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateData()
    }
    
    private func populateData() {
        title = viewModel.name
        creditNumberLabel.text = viewModel.creditNumberString
        skillsLabel.text = viewModel.skillString
        descriptionLabel.text = viewModel.courseDescription
    }

}
