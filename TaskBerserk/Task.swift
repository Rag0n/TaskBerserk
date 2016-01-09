//
//  Task.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData

final class Task: ManagedObject {
    @NSManaged private(set) var id: String
    @NSManaged private(set) var desc: String
    @NSManaged private(set) var status: String
    @NSManaged private(set) var urgency: Double
    @NSManaged private(set) var priority: String?
    @NSManaged private(set) var tags: [String]?
    @NSManaged private(set) var dueDate: NSDate?
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
