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
