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
    var tasks: [TaskMapper] {
        didSet {
            // should update all array of projects if some tasks were added
            ProjectEntity._projects.onNext(Array(ProjectEntity.projectsSet))
        }
    }
    
    // содержит все уникальные проекты с задачами
    static private var projectsSet = Set<ProjectEntity>() {
        didSet {
            _projects.onNext(Array(projectsSet))
        }
    }
    
    // used in segue to show project tasks
    static var projectsArray: Array<ProjectEntity> {
        return Array(ProjectEntity.projectsSet)
    }
    
    static private let _projects = BehaviorSubject<[ProjectEntity]>(value: [])
    static var projects: Observable<[ProjectEntity]> {
        return _projects.asObservable()
    }
    
    /*
        проверяем, существует ли проект с таким названием
        если существует - добавляем задачу в него
        иначе создаем новый проект
    */
    class func addTaskToProject(task: TaskMapper, projectName: String) -> ProjectEntity {
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
    private init(name: String, tasks: [TaskMapper]) {
        self.name = name
        self.tasks = tasks
        self.uuid = NSUUID().UUIDString
    }
    
    // TODO: не добавлять задачу, а проверять уникальность id
    // если задача с таким номером в проекте уже есть, то надо обновить ее данные
    func addTask(task: TaskMapper) {
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
