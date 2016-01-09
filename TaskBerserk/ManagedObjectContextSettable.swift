//
//  ManagedObjectContextSettable.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import CoreData

protocol ManagedObjectContextSettable: class {
    var managedObjectContext: NSManagedObjectContext! { get set }
}
