//
//  Task.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData
import Himotoki

final class Task: ManagedObject {
    @NSManaged private(set) var id: String
    @NSManaged private(set) var name: String
    @NSManaged private(set) var status: String
    @NSManaged private(set) var urgency: Double
    @NSManaged private(set) var priority: String?
    @NSManaged private(set) var dueDate: NSDate?
    
    @NSManaged private(set) var tags: Set<Tag>?
    @NSManaged private(set) var project: Project?
    
    static func insertIntoContext(moc: NSManagedObjectContext, taskMapper: TaskMapper) -> Task {
        let task: Task = moc.insertObject()
        task.id = taskMapper.id
        task.name = taskMapper.name
        task.status = taskMapper.status
        task.urgency = taskMapper.urgency
        task.priority = taskMapper.priority
//        task.project = Project.findOrCreateProject(taskMapper.projectName, inContext: moc)
        // TODO: Реализовать NSDateFormatter
        // TODO: Реализовать конвертирование тэгов из taskEntity в Tags
        // TODO: Реализовать конвертирование dueDate из taskEntity
        return task
    }
    
    static func insertIntoContext(moc: NSManagedObjectContext,
        name: String, project: String? = nil, id: String? = nil,
        status: String? = nil, priority: String? = nil,
        dueDate: String? = nil, urgency: Double? = nil, tags: [String]? = nil) -> Task {

            let task: Task = moc.insertObject()
            task.name = name
            task.id = id ?? NSUUID().UUIDString
            // TODO: implement
            task.status = status ?? "pending"
            task.priority = priority ?? "No priority"
            task.dueDate = nil
            
            task.urgency = urgency ?? Task.calculateUrgency()
            task.project = Project.findOrCreateProject(project ?? "default", inContext: moc)
            if let tags = tags {
                task.tags = Tag.findOrCreateTags(tags, inContext: moc)
            }
            
            return task
    }
    
    func addTags(tagNames: [String]) {
        var existingTags = Array<Tag>()
        if let tags = tags {
            existingTags = Array(tags)
        }
        
        let newTags = Array(Tag.findOrCreateTags(tagNames, inContext: self.managedObjectContext!))
        
        tags = Set(existingTags + newTags)
    }
    
    func changeName(newName: String) {
        name = newName
    }
    
    override func prepareForDeletion() {
        // deletes project if it doesnt have remaining tasks
        if let project = project {
            if project.tasks.filter({ !$0.deleted }).isEmpty {
                print(project)
                managedObjectContext?.deleteObject(project)
            }
        }
        
        // deletes tags if they dont have remaining tasks
        guard let t = tags else { return }
        for tag in t {
            if tag.tasks.filter({ !$0.deleted }).isEmpty {
                managedObjectContext?.deleteObject(tag)
            }
        }
    }
}

// MARK: ManagedObjectType
extension Task: ManagedObjectType {
    static var entityName: String {
        return "Task"
    }
    
    // default sort by urgency
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "urgency", ascending: false)]
    }
}

// MARK: Decodable


// MARK: Private 
extension Task {
    // TODO: implement
    private static func calculateUrgency() -> Double {
        return Double(arc4random_uniform(5))
    }
}
