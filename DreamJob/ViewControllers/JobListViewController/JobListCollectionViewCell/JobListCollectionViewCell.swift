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
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    func populate(from viewModel: ProfileJobListCollectionViewCellViewModelType) {
        nameLabel.attributedText = viewModel.name
        requiredSkillLabel.attributedText = viewModel.totalSkillsString
        
        viewModel.acquiredSkillsString.subscribe(onNext: {[weak self] string in
            self?.acquiredSkillLabel.attributedText = string
        }).disposed(by: disposeBag)
        
        
        viewModel.missingSkillsString.subscribe(onNext: {[weak self] string in
            self?.missingSkillLabel.attributedText = string
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.attributedText = nil
        requiredSkillLabel.attributedText = nil
        acquiredSkillLabel.attributedText = nil
        missingSkillLabel.attributedText = nil
    }

}
