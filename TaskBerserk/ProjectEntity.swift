//
//  ProjectEntity.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

class ProjectEntity {
    private let uuid: String
    var name: String
    var tasks: [TaskEntity] {
        // should update all array of projects if some tasks were added
        didSet {
            ProjectEntity._cellModels.onNext(Array(ProjectEntity.projectsSet))
        }
    }
    
    // содержит все уникальные проекты с задачами
    static private var projectsSet = Set<ProjectEntity>() {
        didSet {
            _cellModels.onNext(Array(projectsSet))
        }
    }
    
//    static private var projectsArray: Array<ProjectEntity> = Array(ProjectEntity.projectsSet) {
//        didSet {
//            _cellModels
//        }
//    }
    
    static private let _cellModels = BehaviorSubject<[ProjectEntity]>(value: [])
    static var projects: Observable<[ProjectEntity]> {
        return _cellModels.asObservable()
    }
    
    /*
        проверяем, существует ли проект с таким названием
        если существует - добавляем задачу в него
        иначе создаем новый проект
    */
    class func addTaskToProject(task: TaskEntity, projectName: String) -> ProjectEntity {
        for project in projectsSet {
            if project.name == projectName {
                project.addTask(task)
                return project
            }
        }
        
        let newProject = ProjectEntity(name: projectName, tasks: [task])
        projectsSet.insert(newProject)
        return newProject
    }
    
    /*
        Приватный, т.к создание проектов происходит
        при создании задач в static методе addTaskToProject.
        Нет смысла создавать пустые проекты.
    */
    private init(name: String, tasks: [TaskEntity]) {
        self.name = name
        self.tasks = tasks
        self.uuid = NSUUID().UUIDString
    }
    
    func addTask(task: TaskEntity) {
        tasks.append(task)
    }
}

// MARK: Hashable
extension ProjectEntity: Hashable {
    var hashValue: Int {
        return NSUUID(UUIDString: self.uuid)!.hashValue
    }
}

// MARK: Equatable
func ==(lhs: ProjectEntity, rhs: ProjectEntity) -> Bool {
    return lhs.uuid == rhs.uuid
}
