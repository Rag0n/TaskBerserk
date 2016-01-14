//
//  ProjectSpec.swift
//  TaskBerserk
//
//  Created by Александр on 13.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import CoreData
@testable import TaskBerserk

class ProjectSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        beforeEach {
            managedObjectContext = createInMemoryManagedObjectContext()
        }
        
        it("creates new project") {
            Task.insertIntoContext(managedObjectContext, name: "task", project: "new project", id: "123", status: "pending", urgency: 2.31)
            
            let result = try! managedObjectContext.executeFetchRequest(Project.sortedFetchRequest) as! [Project]
            
            expect(result.count).toEventually(equal(1))
        }
        
        it("finds an existing project") {
            Task.insertIntoContext(managedObjectContext, name: "task 1", project: "new project", id: "123", status: "pending", urgency: 2.30)
            Task.insertIntoContext(managedObjectContext, name: "task 2", project: "new project", id: "1234", status: "pending", urgency: 2.30)
            
            let result = try! managedObjectContext.executeFetchRequest(Project.sortedFetchRequest) as! [Project]
            
            expect(result.count).toEventually(equal(1))
            expect(result[0].tasks.count).toEventually(equal(2))
        }
        
        it("deletes tasks after deleting a project") {
            Task.insertIntoContext(managedObjectContext, name: "task 1", project: "new project", id: "123", status: "pending", urgency: 2.30)
            Task.insertIntoContext(managedObjectContext, name: "task 2", project: "new project", id: "1234", status: "pending", urgency: 2.30)
            let projects = try! managedObjectContext.executeFetchRequest(Project.sortedFetchRequest) as! [Project]
            let project = projects[0]
            
            managedObjectContext.deleteObject(project)
            let tasks = try! managedObjectContext.executeFetchRequest(Task.sortedFetchRequest) as! [Task]
            
            expect(tasks.count).toEventually(equal(0))
        }
        
        it("deletes project if project doesnt have tasks") {
            let task = Task.insertIntoContext(managedObjectContext, name: "task 1", project: "new project", id: "123", status: "pending", urgency: 2.30)
            
            managedObjectContext.deleteObject(task)
            let projects = try! managedObjectContext.executeFetchRequest(Project.sortedFetchRequest) as! [Project]
            
            expect(projects.count).toEventually(equal(0))
        }
    }
}
