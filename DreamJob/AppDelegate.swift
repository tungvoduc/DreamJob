//
//  AppDelegate.swift
//  DreamJob
//
//  Created by Vo Tung on 17/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        createProfile()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window!)
        
//        createJobsAndSkills()
//        createCourses()
//        assignSkillsToCourse()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // self.saveContext()
    }

}

extension AppDelegate {
    
    func createProfile() {
        let dataStack = DataStack.shared
        let profile = dataStack.createObject(ofType: Profile.self)
        profile.firstName = "Tung"
        profile.lastName = "Vo"
        profile.email = "tung.vo@metropolia.fi"
        profile.id = "1105406"
        dataStack.saveContext()
    }
    
    func createCourses() {
        let dataStack = DataStack.shared
        
        dataStack.deleteAllRecords(ofType: Course.self)
        
        defer { dataStack.saveContext() }
        
        for index in 0..<100 {
            let course = dataStack.createObject(ofType: Course.self)
            course.name = "Course \(index)"
            course.id = String(UUID().uuidString.prefix(10))
            course.credits = Int16(Int.random(min: 2, max: 5))
            course.courseDescription = "This is description for \(course.name!)"
            course.code = String(UUID().uuidString.prefix(5)).uppercased()
        }
    }
    
    func createJobsAndSkills() {
        
        let dataStack = DataStack.shared
        var skills = [Skill]()
        dataStack.deleteAllRecords(ofType: Skill.self)
        
        defer { dataStack.saveContext() }
        
        for _ in 0..<100 {
            let skill = dataStack.createObject(ofType: Skill.self)
            let id = UUID().uuidString
            skill.id = id
            skill.name = "\(id.prefix(5))"
            skill.skillDescription = "Skill description \(id.prefix(5))"
            skills.append(skill)
        }
        
        dataStack.deleteAllRecords(ofType: Job.self)
        
        for index in 0..<100 {
            let job = dataStack.createObject(ofType: Job.self)
            job.name = "Job \(index)"
            job.jobDescription = "Job description \(index)"
            job.id = UUID().uuidString
            
            let numberOfSkills = Int.random(min: min(4, skills.count - 1), max: min(7, skills.count - 1))
            var addedSet = Set<Int>()
            
            while addedSet.count < numberOfSkills {
                let number = Int.random(min: 0, max: skills.count - 1)
                
                if !addedSet.contains(number) {
                    addedSet.insert(number)
                    job.addToSkills(skills[number])
                }
            }
        }
    }
    
    func assignSkillsToCourse() {
        let dataStack = DataStack.shared
        let courses = dataStack.allRecords(ofType: Course.self)
        let skills = dataStack.allRecords(ofType: Skill.self)
        
        let profile = dataStack.allRecords(ofType: Profile.self).first
        
        for course in courses {
            let numberOfSkills = Int.random(min: 3, max: min(5, skills.count - 1))
            var addedSet = Set<Int>()
            
            // Add course skills
            while addedSet.count < numberOfSkills {
                let number = Int.random(min: 0, max: skills.count - 1)
                
                if !addedSet.contains(number) {
                    addedSet.insert(number)
                    course.addToSkills(skills[number])
                }
            }
            
            // Add course required skills
            let numberOfRequiredSkills = Int.random(min: 0, max: min(2, skills.count - 1))
            var requiredSet = Set<Int>()
            
            while requiredSet.count < numberOfRequiredSkills {
                let number = Int.random(min: 0, max: skills.count - 1)
                
                if !addedSet.contains(number) && !requiredSet.contains(number) {
                    requiredSet.insert(number)
                    course.addToRequiredSkills(skills[number])
                }
            }
            
            if Bool.random() {
                if let profile = profile {
                    profile.addToCompletedCourses(course)
                }
            }
        }
        
        
        dataStack.saveContext()
    }
    
}

