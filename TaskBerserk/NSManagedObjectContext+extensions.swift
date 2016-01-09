//
//  NSManagedObjectContext+extensions.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
        guard let object = NSEntityDescription
            .insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else {
                fatalError("Wrong object type")
        }
        
        return object
    }
}
