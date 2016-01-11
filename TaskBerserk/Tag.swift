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
    
    static func findOrCreateTags(tagNames: [String], inContext moc: NSManagedObjectContext) -> [Tag] {
        var tags = [Tag]()
        
        for tagName in tagNames {
            tags.append(Tag.findOrCreateTag(tagName, inContext: moc))
        }
        
        return tags
    }
    
    static func findOrCreateTag(tagName: String, inContext moc: NSManagedObjectContext) -> Tag {
        let predicate = NSPredicate(format: "name == %@", tagName)
        let tag = findOrCreateInContext(moc, matchingPredicate: predicate) { tag in
            tag.name = tagName
            tag.updatedAt = NSDate()
        }
        return tag
    }
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
