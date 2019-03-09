//
//  JobListCollectionViewCellViewModel.swift
//  DreamJob
//
//  Created by Vo Tung on 03/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: JobListCollectionViewCellViewModelType
protocol JobListCollectionViewCellViewModelType {
    var name: String { get }
    var totalSkillsString: String { get }
    var job: Job { get }
}

// MARK: ProfileJobListCollectionViewCellViewModelType
protocol ProfileJobListCollectionViewCellViewModelType: JobListCollectionViewCellViewModelType {
    
    // Have to be ReplaySubject because of cell reusable
    var acquiredSkillsString: ReplaySubject<String> { get }
    var missingSkillsString: ReplaySubject<String> { get }
    var profile: Profile { get }
}

// MARK: ProfileJobListCollectionViewCellViewModel
class ProfileJobListCollectionViewCellViewModel: ProfileJobListCollectionViewCellViewModelType {
    
    var acquiredSkillsString: ReplaySubject<String>
    
    var missingSkillsString: ReplaySubject<String>
    
    var name: String
    
    var totalSkillsString: String
    
    private let disposeBag = DisposeBag()
    
    private(set) var job: Job
    
    private(set) var profile: Profile
    
    init(profile: Profile, job: Job) {
        self.profile = profile
        self.job = job
        
        name = job.name ?? "No job name"

        if let skills = (job.skills?.allObjects as? [Skill])?.compactMap({ $0.name }), !skills.isEmpty {
            if skills.count == 1 {
                totalSkillsString = "Skills required: \(skills[0])"
            } else {
                totalSkillsString = "Skills required: \(skills.joined(separator: ", "))"
            }
        } else {
            totalSkillsString = "No skills required"
        }
        
        acquiredSkillsString = ReplaySubject<String>.create(bufferSize: 1)
        
        profile.rx.acquiredSkills
            .map ({ acquiredSkills -> Set<Skill> in
                var skillSet = Set<Skill>()
                if let jobSkills = job.skills as? Set<Skill> {
                    for jobSkill in jobSkills {
                        if acquiredSkills.contains(where: { $0.hasSamePrimaryKey(with: jobSkill) }) {
                            skillSet.insert(jobSkill)
                        }
                    }
                }
                return skillSet
            })
            .map { $0.compactMap { $0.name } }
            .map { Array($0) }
            .map { $0.sorted().joined(separator: ", ") }
            .map { $0.isEmpty ? "None" : $0 }
            .map { "Already have: \($0)" }
            .bind(to: self.acquiredSkillsString)
            .disposed(by: disposeBag)
        
        missingSkillsString = ReplaySubject<String>.create(bufferSize: 1)
        
        profile.rx.acquiredSkills
            .map ({ acquiredSkills -> Set<Skill> in
                var skillSet = Set<Skill>()
                if let jobSkills = job.skills as? Set<Skill> {
                    for jobSkill in jobSkills {
                        if !acquiredSkills.contains(where: { $0.hasSamePrimaryKey(with: jobSkill) }) {
                            skillSet.insert(jobSkill)
                        }
                    }
                }
                return skillSet
            })
            .map { $0.compactMap { $0.name } }
            .map { Array($0) }
            .map { $0.sorted().joined(separator: ", ") }
            .map { $0.isEmpty ? "None" : $0 }
            .map { "Mssing: \($0)" }
            .bind(to: self.missingSkillsString)
            .disposed(by: disposeBag)
    }
    
}
