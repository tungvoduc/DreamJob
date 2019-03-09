//
//  JobListCollectionViewCell.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift

class JobListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var requiredSkillLabel: UILabel!
    @IBOutlet weak var acquiredSkillLabel: UILabel!
    @IBOutlet weak var missingSkillLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(from viewModel: ProfileJobListCollectionViewCellViewModelType) {
        nameLabel.text = viewModel.name
        requiredSkillLabel.text = viewModel.totalSkillsString
        
        viewModel.acquiredSkillsString.subscribe(onNext: {[weak self] string in
            self?.acquiredSkillLabel.text = string
        }).disposed(by: disposeBag)
        
        
        viewModel.missingSkillsString.subscribe(onNext: {[weak self] string in
            self?.missingSkillLabel.text = string
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        requiredSkillLabel.text = nil
        acquiredSkillLabel.text = nil
        missingSkillLabel.text = nil
    }

}
