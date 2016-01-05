//
//  ProjectEntity.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class ProjectEntity {
    private let uuid: String
    var name: String
    var tasks: [TaskEntity]
    
    // содержит все уникальные проекты с задачами
    static var projects = Set<ProjectEntity>()
    
    /*
        проверяем, существует ли проект с таким названием
        если существует - добавляем задачу в него
        иначе создаем новый проект
    */
    class func addTaskToProject(task: TaskEntity, projectName: String) -> ProjectEntity {
        for project in projects {
            if project.name == projectName {
                project.addTask(task)
                return project
            }
        }
        
        let newProject = ProjectEntity(name: projectName, tasks: [task])
        projects.insert(newProject)
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
