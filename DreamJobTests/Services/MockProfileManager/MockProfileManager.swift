//
//  MockProfileManager.swift
//  DreamJobTests
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
@testable import DreamJob

class MockProfileManager: ProfileManaging {
    func createProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String) -> Profile {
        let profile = Profile()
        profile.email = email
        profile.id = studentId
        profile.address = address
        profile.lastName = lastName
        profile.firstName = firstName
        profile.dateOfBirth = dateOfBirth
        profile.socialSecurityNumber = socialSecurityNumber
        self.profile = profile
        return profile
    }
    
    
    var profile: Profile?
    
    var didSetNewProfile = false
    
    func currentProfile() -> Profile? {
        return profile
    }
    
    func setProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String) {
        didSetNewProfile = true
        
        if profile == nil {
            profile = Profile()
        }
    }
    
}
