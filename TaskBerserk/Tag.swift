//
//  Tag.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData

final class Tag: ManagedObject {
    @NSManaged private(set) var name: String
    @NSManaged private(set) var updatedAt: NSDate
    @NSManaged private(set) var tasks: Set<Task>
}

// MARK: ManagedObjectType
extension Tag: ManagedObjectType {
    static var entityName: String {
        return "Tag"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}
