//
//  ManagedObject.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData

class ManagedObject: NSManagedObject {
    
}

protocol ManagedObjectType {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension ManagedObjectType {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension ManagedObjectType where Self: ManagedObject {
    
    /// returns existing object(object can be in context or in db) or creates and configures a new on
    static func findOrCreateInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self {
        guard let obj = findOrFetchInContext(moc, matchingPredicate: predicate) else {
            // if doesnt exitst, then create and configure
            let newObject: Self = moc.insertObject()
            configure(newObject)
            return newObject
        }
        return obj
    }
    
    /// Checks if required object is already registered in the context(performance optimization)
    static func findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        // return if object already in context
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate) else {
            // else execute a fetch request
            return fetchInContext(moc) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return obj
    }
    
    /// executes a fetch request with configuration block
    static func fetchInContext(context: NSManagedObjectContext,
        @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self] {
            
        let request = NSFetchRequest(entityName: Self.entityName)
        configurationBlock(request)
        guard let result = try! context.executeFetchRequest(request) as? [Self] else {
            fatalError("Fetched objects have wrong type")
        }
        return result
    }
    
    /// iterates over objects in context(memory) until finds required one
    static func materializedObjectInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in moc.registeredObjects where !obj.fault {
            guard let res = obj as? Self where predicate.evaluateWithObject(res) else { continue }
            return res
        }
        return nil
    }
    
    static func countInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> Int {
        let request = NSFetchRequest(entityName: entityName)
        configurationBlock(request)
        var error: NSError?
        let result = context.countForFetchRequest(request, error: &error)
        guard result != NSNotFound else {
            fatalError("Failed to execute fetch request: \(error)")
        }
        return result
    }
}
