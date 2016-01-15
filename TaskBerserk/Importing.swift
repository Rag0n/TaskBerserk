//
//  Importing.swift
//  TaskBerserk
//
//  Created by Александр on 15.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

protocol Importing: ManagedObjectContextSettable {
    var webService: TaskWebService { get }
    func importTasks()
}
