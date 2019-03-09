//
//  ProfileUpdateViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileUpdateViewModeling {
    
    var isSubmitButtonEnabled: Observable<Bool> { get }
    
    var submitButtonTapped: AnyObserver<Void> { get }
    var didSetNewProfile: Observable<Profile> { get }
    
    // Birthdate
    var updateBirthdate: AnyObserver<Date?> { get }
    var didUpdateBirthdate: Observable<Date?> { get }
    
    // Info
    var email: BehaviorSubject<String> { get }
    var address: BehaviorSubject<String> { get }
    var firstName: BehaviorSubject<String> { get }
    var lastName: BehaviorSubject<String> { get }
    var socialSecurityNumber: BehaviorSubject<String> { get }
    var studentId: BehaviorSubject<String> { get }
    var dateOfBirth: Observable<String> { get }
    
}

class ProfileUpdateViewModel: ProfileUpdateViewModeling {
    
    var updateBirthdate: AnyObserver<Date?>

    var didUpdateBirthdate: Observable<Date?>
    
    var isSubmitButtonEnabled: Observable<Bool>
    
    var submitButtonTapped: AnyObserver<Void>
    
    var didSetNewProfile: Observable<Profile>
    
    var email: BehaviorSubject<String>
    
    var address: BehaviorSubject<String>
    
    var firstName: BehaviorSubject<String>
    
    var lastName: BehaviorSubject<String>
    
    var socialSecurityNumber: BehaviorSubject<String>
    
    var studentId: BehaviorSubject<String>
    
    var dateOfBirth: Observable<String>
    
    private let coreDataStack: CoreDataStack
    
    private let disposeBag = DisposeBag()
    
    init(coreDataStack: CoreDataStack = DataStack.shared, profileManager: ProfileManaging = ProfileManager()) {
        self.coreDataStack = coreDataStack
        let _email = BehaviorSubject<String>.init(value: "")
        let _address = BehaviorSubject<String>.init(value: "")
        let _firstName = BehaviorSubject<String>.init(value: "")
        let _lastName = BehaviorSubject<String>.init(value: "")
        let _socialSecurityNumber = BehaviorSubject<String>.init(value: "")
        let _studentId = BehaviorSubject<String>.init(value: "")
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        
        email = _email
        address = _address
        firstName = _firstName
        lastName = _lastName
        socialSecurityNumber = _socialSecurityNumber
        studentId = _studentId
        
        
        // Select birthdate
        let _updateBirthdate = BehaviorSubject<Date?>.init(value: nil)
        updateBirthdate = _updateBirthdate.asObserver()
        didUpdateBirthdate = _updateBirthdate.asObservable().share(replay: 1)
        
        dateOfBirth = didUpdateBirthdate
            .map({ date -> String in
                if let date = date {
                    return formatter.string(from: date)
                }
                
                return ""
            })
        
        let validEmail = _email.asObservable()
            .share(replay: 1)
            .map { !$0.isEmpty }
        let validAddress = _address.asObservable()
            .share(replay: 1)
            .map { !$0.isEmpty }
        let validFirstName = _firstName.asObservable()
            .share(replay: 1)
            .map { !$0.isEmpty }
        let validLastName = _lastName.asObservable()
            .share(replay: 1)
            .map { !$0.isEmpty }
        let validSocialSecurityNumber = _socialSecurityNumber.asObservable()
            .share(replay: 1)
            .map { !$0.isEmpty }
        let validStudentId = _studentId.asObservable()
            .share(replay: 1)
            .map { !$0.isEmpty }
        let validDateOfBirth = _updateBirthdate.asObservable()
            .share(replay: 1)
            .map { $0 != nil }
        
        let isProfileValid = Observable.combineLatest(validEmail, validAddress, validFirstName, validLastName, validSocialSecurityNumber, validStudentId, validDateOfBirth) { $0 && $1 && $2 && $3 && $4 && $5 && $6 }
        isSubmitButtonEnabled = isProfileValid.share(replay: 1)
        
        let _submitButtonTapped = PublishSubject<Void>()
        submitButtonTapped = _submitButtonTapped.asObserver()
        
        let _setNewProfile = PublishSubject<Profile>()
        didSetNewProfile = _setNewProfile.asObservable()
        
        _submitButtonTapped.asObservable()
            .flatMap {
                isProfileValid.share(replay: 1)
            }
            .subscribe(onNext: { isValid in
                if isValid {
                    do {
                        guard let dob = try _updateBirthdate.value() else {
                            return
                        }
                        
                        let email = try _email.value()
                        let address = try _address.value()
                        let firstName = try _firstName.value()
                        let lastName = try _lastName.value()
                        let ssn = try _socialSecurityNumber.value()
                        let id = try _studentId.value()
                        
                        let profile = profileManager.createProfile(with: email, studentId: id, firstName: firstName, lastName: lastName, socialSecurityNumber: ssn, dateOfBirth: dob, address: address)
                        _setNewProfile.asObserver().onNext(profile)
                        
                    } catch {
                        print("Not handle")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}
