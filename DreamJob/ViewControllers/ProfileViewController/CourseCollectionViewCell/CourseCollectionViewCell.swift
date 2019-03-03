//
//  CourseCollectionViewCell.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditNumberLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.text = ""
        creditNumberLabel.text = ""
        skillsLabel.text = ""
    }
    
    func populate(from viewModel: CourseCollectionViewCellViewModelType) {
        nameLabel.text = viewModel.name
        creditNumberLabel.text = viewModel.creditNumberString
        skillsLabel.text = viewModel.skillString
    }

}
