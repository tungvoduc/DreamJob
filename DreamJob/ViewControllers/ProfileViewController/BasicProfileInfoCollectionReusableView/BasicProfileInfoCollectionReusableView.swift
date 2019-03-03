//
//  BasicProfileInfoCollectionReusableView.swift
//  DreamJob
//
//  Created by Vo Tung on 02/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxSwift

class BasicProfileInfoCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var studentNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var creditNumberLabel: UILabel!
    @IBOutlet weak var skillNumberLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fullNameLabel.text = ""
        studentNumberLabel.text = ""
        emailLabel.text = ""
        creditNumberLabel.text = BasicProfileInfoCollectionReusableView.stringFor(numberOfCredits: 0)
        skillNumberLabel.text = BasicProfileInfoCollectionReusableView.stringFor(numberOfSkills: 0)
    }
    
    func populate(from viewModel: BasicProfileInfoViewModelType) {
        viewModel.fullName
            .drive(fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.studentNumber
            .drive(studentNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.email
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalCredits
            .map { BasicProfileInfoCollectionReusableView.stringFor(numberOfCredits: $0) }
            .drive(creditNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalSKills
            .map { BasicProfileInfoCollectionReusableView.stringFor(numberOfSkills: $0) }
            .drive(skillNumberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private static func stringFor(numberOfSkills: Int) -> String {
        if numberOfSkills <= 0 {
            return "0 skills"
        } else if numberOfSkills == 1 {
            return "1 skill"
        } else {
            return "\(numberOfSkills) skills"
        }
    }
    
    private static func stringFor(numberOfCredits: Int) -> String {
        if numberOfCredits <= 0 {
            return "0 credits"
        } else if numberOfCredits == 1 {
            return "1 credit"
        } else {
            return "\(numberOfCredits) credits"
        }
    }
    
}
