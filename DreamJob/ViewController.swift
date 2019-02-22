//
//  ViewController.swift
//  DreamJob
//
//  Created by Vo Tung on 17/02/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let course = Course()
        let job = Job()
        let profile = Profile()
        let skill = Skill()
        
        profile.addToCompletedCourses(course)
        job.addToSkills(skill)
        course.addToSkills(skill)
        
    }


}

