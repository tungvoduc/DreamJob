//
//  Profile+Rx.swift
//  DreamJob
//
//  Created by Vo Tung on 26/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: Profile {
    
    var firstName: Observable<String?> {
        return observe(String.self, #keyPath(Profile.firstName))
            .startWith(base.firstName)
            .distinctUntilChanged()
            .share()
    }
    
    var lastName: Observable<String?> {
        return observe(String.self, #keyPath(Profile.lastName))
            .startWith(base.lastName)
            .distinctUntilChanged()
            .share()
    }
    
    var address: Observable<String?> {
        return observe(String.self, #keyPath(Profile.address))
            .startWith(base.address)
            .distinctUntilChanged()
            .share()
    }
    
    var id: Observable<String?> {
        return observe(String.self, #keyPath(Profile.id))
            .startWith(base.id)
            .distinctUntilChanged()
            .share()
    }
    
    var email: Observable<String?> {
        return observe(String.self, #keyPath(Profile.email))
            .startWith(base.email)
            .distinctUntilChanged()
            .share()
    }
    
    var socialSecurityNumber: Observable<String?> {
        return observe(String.self, #keyPath(Profile.socialSecurityNumber))
            .startWith(base.socialSecurityNumber)
            .distinctUntilChanged()
            .share()
    }
    
    var dateOfBirth: Observable<Date?> {
        return observe(Date.self, #keyPath(Profile.dateOfBirth))
            .startWith(base.dateOfBirth)
            .distinctUntilChanged()
            .share()
    }
    
}
