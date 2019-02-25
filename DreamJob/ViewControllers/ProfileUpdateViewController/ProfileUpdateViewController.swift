//
//  ProfileUpdateViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 20/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileUpdateViewController: UIViewController {
    
    let viewModel: ProfileUpdateViewModeling
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var socialNumberTextField: UITextField!
    @IBOutlet weak var studentNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    init(viewModel model: ProfileUpdateViewModeling) {
        viewModel = model
        super.init(nibName: "ProfileUpdateViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUIElements()
        setUpBindings()
    }
    
    private func setUpUIElements() {
        submitButton.isEnabled = false
    }
    
    private func setUpBindings() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        studentNumberTextField.rx.text
            .orEmpty
            .bind(to: viewModel.studentId)
            .disposed(by: disposeBag)
        
        firstNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        addressTextField.rx.text
            .orEmpty
            .bind(to: viewModel.address)
            .disposed(by: disposeBag)
        
        socialNumberTextField.rx.text
            .orEmpty
            .bind(to: viewModel.socialSecurityNumber)
            .disposed(by: disposeBag)
        
        viewModel.dateOfBirth
            .bind(to: birthdateTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isSubmitButtonEnabled
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: disposeBag)
    }

}
