//
//  TagSpec.swift
//  TaskBerserk
//
//  Created by Александр on 14.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import CoreData
@testable import TaskBerserk

class TagSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        beforeEach {
            managedObjectContext = createInMemoryManagedObjectContext()
        }
        
        it("creates new tags") {
            Task.insertIntoContext(managedObjectContext, name: "task", project: "new project", id: "123", status: "pending", urgency: 2.31, tags: ["tag1", "tag2"])
            
            let tags = try! managedObjectContext.executeFetchRequest(Tag.sortedFetchRequest) as! [Tag]
            
            expect(tags.count).toEventually(equal(2))
        }
        
        it("find an existing tags") {
            Task.insertIntoContext(managedObjectContext, name: "task1", project: "new project", id: "123", status: "pending", urgency: 2.31, tags: ["tag1", "tag2"])
            Task.insertIntoContext(managedObjectContext, name: "task2", project: "new project", id: "123", status: "pending", urgency: 2.31, tags: ["tag1", "tag2"])
            
            let tags = try! managedObjectContext.executeFetchRequest(Tag.sortedFetchRequest) as! [Tag]
            
            expect(tags.count).toEventually(equal(2))
            expect(tags[0].tasks.count).toEventually(equal(2))
            expect(tags[1].tasks.count).toEventually(equal(2))
        }

        it("doesnt deletes tasks after deleting tag which contain those tasks") {
            Task.insertIntoContext(managedObjectContext, name: "task1", project: "new project", id: "123", status: "pending", urgency: 2.31, tags: ["tag1", "tag2"])
            let tags = try! managedObjectContext.executeFetchRequest(Tag.sortedFetchRequest) as! [Tag]
            let tagFirst = tags[0]
            let tagSecond = tags[0]
            
            managedObjectContext.deleteObject(tagFirst)
            managedObjectContext.deleteObject(tagSecond)
            let tasks = try! managedObjectContext.executeFetchRequest(Task.sortedFetchRequest) as! [Task]
            
            expect(tasks.count).toEventually(equal(1))
        }
//
        it("deletes tag if tag doesnt have tasks anymore") {
            let task = Task.insertIntoContext(managedObjectContext, name: "task1", project: "new project", id: "123", status: "pending", urgency: 2.31, tags: ["tag"])
            
            managedObjectContext.deleteObject(task)
            let tags = try! managedObjectContext.executeFetchRequest(Tag.sortedFetchRequest) as! [Tag]
            
            expect(tags.count).toEventually(equal(0))
        }
    }
}
