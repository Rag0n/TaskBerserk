//
//  ProjectEntitySpec.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import Himotoki
import RxSwift
@testable import TaskBerserk

class ProjectEntitySpec: QuickSpec {
    override func spec() {
        let disposeBag = DisposeBag()
        it("adds task to existing project") {
            var newTaskJSON = taskJSON
            newTaskJSON["project"] = "Existing project"
            let firstTask: TaskEntity = try! decode(newTaskJSON)
            let secondTask: TaskEntity = try! decode(newTaskJSON)
            
            expect(firstTask.project?.name) == "Existing project"
            expect(secondTask.project?.name) == "Existing project"
            expect(firstTask.project) == secondTask.project
        }
        
        it("adds task and creates new project") {
            let newTask: TaskEntity = try! decode(taskJSON)
            
            expect(newTask.project?.name) == "testproject"
        }
        
        it("updates static projects if new task was added") {
            var projectsUpdated = false
            ProjectEntity.projects.subscribeNext { _ in
                projectsUpdated = true
            }.addDisposableTo(disposeBag)
            
            let _: TaskEntity = try! decode(taskJSON)
            
            expect(projectsUpdated).toEventually(beTrue())
        }
    }
}