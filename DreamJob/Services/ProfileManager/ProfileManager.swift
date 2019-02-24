//
//  ProfileManager.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

protocol ProfileManaging {
    func setProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String)
    func currentProfile() -> Profile?
}

extension ProfileManaging {
    func hasProfile() -> Bool {
        return currentProfile() != nil
    }
}

class ProfileManager: ProfileManaging {
    
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = DataStack()) {
        self.coreDataStack = coreDataStack
    }
    
    func setProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String) {
        
    }
    
    func currentProfile() -> Profile? {
        let profiles = coreDataStack.allRecords(ofType: Profile.self)
        return profiles.count > 0 ? profiles.first : nil
    }
    
}
