//
//  CoreDataStack.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData

private let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("TaskBerserk.taskberserk")

func createMainContext(concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
    // get bundle where object model resides
    let bundles = [NSBundle(forClass: Task.self)]
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
        fatalError("Model is not found")
    }
    
    // configure managed context
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: concurrencyType)
    context.persistentStoreCoordinator = psc
    
    return context
}
