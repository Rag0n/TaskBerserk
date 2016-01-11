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
