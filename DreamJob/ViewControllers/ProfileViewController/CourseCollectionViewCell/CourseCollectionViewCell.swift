//
//  CourseCollectionViewCell.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditNumberLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.text = ""
        creditNumberLabel.text = ""
        skillsLabel.text = ""
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func populate(from viewModel: CourseCollectionViewCellViewModelType) {
        nameLabel.text = viewModel.name
        creditNumberLabel.text = viewModel.creditNumberString
        skillsLabel.text = viewModel.skillString
        
        viewModel.isCompleted
            .subscribe(onNext: { [weak self] isCompleted in
                if let strongSelf = self {
                    strongSelf.statusView.backgroundColor = isCompleted ? UIColor.available : UIColor.notAvailable
                }
            })
            .disposed(by: disposeBag)
    }

}
