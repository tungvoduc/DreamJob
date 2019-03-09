//
//  ProfileManager.swift
//  DreamJob
//
//  Created by Vo Tung on 24/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation

protocol ProfileManaging {
    func createProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String) -> Profile
    func currentProfile() -> Profile?
}

extension ProfileManaging {
    func hasProfile() -> Bool {
        return currentProfile() != nil
    }
}

class ProfileManager: ProfileManaging {
    
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = DataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    func createProfile(with email: String, studentId: String, firstName: String, lastName: String, socialSecurityNumber: String, dateOfBirth: Date, address: String) -> Profile {
        let profile = coreDataStack.createObject(ofType: Profile.self)
        profile.email = email
        profile.id = studentId
        profile.address = address
        profile.lastName = lastName
        profile.firstName = firstName
        profile.dateOfBirth = dateOfBirth
        profile.socialSecurityNumber = socialSecurityNumber
        coreDataStack.saveContext()
        return profile
    }
    
    func currentProfile() -> Profile? {
        let profiles = coreDataStack.allRecords(ofType: Profile.self)
        return profiles.count > 0 ? profiles.first : nil
    }
    
}
