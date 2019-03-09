//
//  JobViewModelDataCreator.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: JobViewModelDataCreatorType
class JobViewModelDataCreator {
    
    var acquiredSkills: Observable<Set<Skill>>
    
    var job: Job
    
    private var boldFont = UIFont.boldSystemFont(ofSize: 17)
    
    private var defaultFont = UIFont.systemFont(ofSize: 17)
    
    private var placeholderTextColor = UIColor.gray
    
    private var defaultTextColor = UIColor.black
    
    init(acquiredSkills: Observable<Set<Skill>>, job: Job) {
        self.acquiredSkills = acquiredSkills
        self.job = job
    }
    
    func jobNameAttributedString() -> NSAttributedString {
        if let name = job.name {
            return NSAttributedString(string: name, font: boldFont, textColor: defaultTextColor)
        }
        return NSAttributedString(string: "Invalid name", font: boldFont, textColor: placeholderTextColor)
    }
    
    func totalSkillsString() -> NSAttributedString {
        if let skills = (job.skills?.allObjects as? [Skill])?.compactMap({ $0.name }), !skills.isEmpty {
            let prefixAttributedString = NSMutableAttributedString(string: "Skills required: ", font: boldFont, textColor: defaultTextColor)
            let suffixAttributedString: NSAttributedString
            if skills.count == 1 {
                suffixAttributedString = NSAttributedString(string: skills[0], font: defaultFont, textColor: defaultTextColor)
            } else {
                suffixAttributedString = NSAttributedString(string: "\(skills.joined(separator: ", "))", font: defaultFont, textColor: defaultTextColor)
            }
            prefixAttributedString.append(suffixAttributedString)
            return prefixAttributedString
        } else {
            return NSAttributedString(string: "No skills required", font: boldFont, textColor: placeholderTextColor)
        }
    }
    
    func acquiredSkillsString(disposedBy disposeBag: DisposeBag) -> Observable<NSAttributedString> {
        let acquiredSkillsString = ReplaySubject<NSAttributedString>.create(bufferSize: 1)
        
        acquiredSkills
            .map ({ [unowned self] acquiredSkills -> Set<Skill> in
                var skillSet = Set<Skill>()
                if let jobSkills = self.job.skills as? Set<Skill> {
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
            .map({ string -> NSAttributedString in
                let prefixAttributedString = NSMutableAttributedString(string: "Already have: ", font: self.boldFont, textColor: UIColor.available)
                let suffixAttributedString: NSAttributedString
                
                if string.isEmpty {
                    suffixAttributedString = NSAttributedString(string: "None", font: self.defaultFont, textColor: self.placeholderTextColor)
                } else {
                    suffixAttributedString = NSAttributedString(string: string, font: self.defaultFont, textColor: self.defaultTextColor)
                }
                prefixAttributedString.append(suffixAttributedString)
                return prefixAttributedString
            })
            .bind(to: acquiredSkillsString)
            .disposed(by: disposeBag)
        
        return acquiredSkillsString.asObservable()
            .share(replay: 1)
    }
    
    func missingSkillsString(disposedBy disposeBag: DisposeBag) -> Observable<NSAttributedString> {
        let missingSkillsString = ReplaySubject<NSAttributedString>.create(bufferSize: 1)
        
        acquiredSkills
            .map ({ [unowned self] acquiredSkills -> Set<Skill> in
                var skillSet = Set<Skill>()
                if let jobSkills = self.job.skills as? Set<Skill> {
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
            .map({ string -> NSAttributedString in
                let prefixAttributedString = NSMutableAttributedString(string: "Missing: ", font: self.boldFont, textColor: UIColor.notAvailable)
                let suffixAttributedString: NSAttributedString
                
                if string.isEmpty {
                    suffixAttributedString = NSAttributedString(string: "None", font: self.defaultFont, textColor: self.placeholderTextColor)
                } else {
                    suffixAttributedString = NSAttributedString(string: string, font: self.defaultFont, textColor: self.defaultTextColor)
                }
                prefixAttributedString.append(suffixAttributedString)
                return prefixAttributedString
            })
            .bind(to: missingSkillsString)
            .disposed(by: disposeBag)
        
        return missingSkillsString.asObservable()
            .share(replay: 1)
    }
    
    func studyPathAlternativeCountString(disposedBy disposeBag: DisposeBag) -> Observable<NSAttributedString> {
        return Observable.from(optional: NSAttributedString(string: "125 options to get all skills this job required", font: boldFont, textColor: defaultTextColor))
            .share(replay: 1)
    }
    
}
