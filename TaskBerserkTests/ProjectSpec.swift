//
//  ProjectSpec.swift
//  TaskBerserk
//
//  Created by Александр on 13.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
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
        describe("project") {
            it("creates new project") {
                Task.insertIntoContext(managedObjectContext, name: "task", project: "new project", id: "123", status: "pending", urgency: 2.31)
                
                let result = try! managedObjectContext.executeFetchRequest(Project.sortedFetchRequest) as! [Project]
                
                expect(result).notTo(beNil())
                expect(result.count).toEventually(equal(1))
            }
            
            it("finds an existing project") {
                Task.insertIntoContext(managedObjectContext, name: "task 1", project: "new project", id: "123", status: "pending", urgency: 2.30)
                Task.insertIntoContext(managedObjectContext, name: "task 2", project: "new project", id: "1234", status: "pending", urgency: 2.30)
                
                let result = try! managedObjectContext.executeFetchRequest(Project.sortedFetchRequest) as! [Project]
                
                expect(result.count).toEventually(equal(1))
                expect(result[0].tasks.count).toEventually(equal(2))
            }
        }
        
    }
}
