//
//  Project.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData

final class Project: ManagedObject {
    @NSManaged private(set) var name: String
    @NSManaged private(set) var updatedAt: NSDate
    @NSManaged private(set) var tasks: Set<Task>
    
    static func findOrCreateProject(projectName: String, inContext moc: NSManagedObjectContext) -> Project {
        let predicate = NSPredicate(format: "name = %@", projectName)
        let project = findOrCreateInContext(moc, matchingPredicate: predicate) { project in
            project.name = projectName
            project.updatedAt = NSDate()
        }
        return project
    }
    
    override var description: String {
        return "\(name)"
    }
}

// MARK: ManagedObjectType
extension Project: ManagedObjectType {
    static var entityName: String {
        return "Project"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}

// MARK: NameWithCountRepresentable
extension Project: NameWithCountRepresentable {
    var nameString: String {
        return name
    }
    
    var countString: String {
        return "\(tasks.count)"
    }
}
