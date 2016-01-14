//
//  TaskSpec.swift
//  TaskBerserk
//
//  Created by Александр on 14.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import CoreData
@testable import TaskBerserk

class TaskSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        beforeEach {
            managedObjectContext = createInMemoryManagedObjectContext()
        }
        
        it("inserts new task into context") {
            Task.insertIntoContext(managedObjectContext, name: "Test Task", project: "Testing", id: "1", status: "pending", priority: "H", dueDate: nil, urgency: nil, tags: ["@computer"])
            let fetchRequest = NSFetchRequest(entityName: Task.entityName)
            let predicate = NSPredicate(format: "name = %@", "Test Task")
            fetchRequest.predicate = predicate
            
            let fetchResult = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Task]
            let fetchedTask = fetchResult[0]
        
            expect(fetchedTask).notTo(beNil())
            expect(fetchedTask.name).toEventually(equal("Test Task"))
            expect(fetchedTask.project?.name).toEventually(equal("Testing"))
            expect(fetchedTask.id).toEventually(equal("1"))
            expect(fetchedTask.status).toEventually(equal("pending"))
            expect(fetchedTask.priority).toEventually(equal("H"))
            expect(fetchedTask.tags?.first?.name).toEventually(equal("@computer"))
        }
    }
}
