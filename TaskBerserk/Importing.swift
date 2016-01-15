//
//  Importing.swift
//  TaskBerserk
//
//  Created by Александр on 15.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import CoreData

protocol Importing {
    func initWithContext(context: NSManagedObjectContext, webService: TaskWebService)
    func importTasks()
}
