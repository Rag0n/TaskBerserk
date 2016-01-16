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
    @NSManaged private(set) var project: Project
    
    
    static func updateOrCreateTask(moc: NSManagedObjectContext,
        name: String, status: String = "Pending", project: String? = nil, id: String? = nil, priority: String? = nil,
        dueDate: String? = nil, urgency: Double? = nil, tags: [String]? = nil) -> Task {

            var task: Task
            if let id = id {
                let predicate = NSPredicate(format: "id = %@", id)
                task = findOrCreateInContext(moc, matchingPredicate: predicate) { _ in }
            } else {
                task = moc.insertObject()
            }

            task.id = id ?? NSUUID().UUIDString
            
            task.name = name
            task.status = status
            task.priority = priority
            
            // TODO: implement
            task.dueDate = nil
            
            task.project = Project.findOrCreateProject(project, inContext: moc)
            
            if let tags = tags {
                task.tags = Tag.findOrCreateTags(tags, inContext: moc)
            }
            
            task.urgency = Task.calculateUrgency()
            
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

        if project.tasks.filter({ !$0.deleted }).isEmpty {
            managedObjectContext?.deleteObject(project)
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
