//
//  TaskMapperSpec.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import Himotoki
@testable import TaskBerserk

class TaskMapperSpec: QuickSpec {
    override func spec() {
        context("parses JSON data") {
            it("to create a new instance") {
                let task: TaskMapper? = try? decode(taskJSON)
                
                expect(task).notTo(beNil())
                expect(task?.name) == "first task"
                expect(task?.project) == "testproject"
                expect(task?.urgency) == 8.00959
                expect(task?.status) == "pending"
                expect(task?.tags) == ["first tag", "second tag"]
                expect(task?.priority) == "H"
                expect(task?.dueDate) == "Wed, 6 Jan 2016 20:06:47 +0000"
            }
            
            it("to create a new instance when optional data are misssed") {
                var missingJSON = taskJSON
                missingJSON["due"] = nil
                missingJSON["priority"] = nil
                missingJSON["tags"] = nil
                missingJSON["project"] = nil
                let task: TaskMapper? = try? decode(missingJSON)
                
                expect(task).notTo(beNil())
                expect(task?.dueDate).to(beNil())
                expect(task?.tags).to(beNil())
                expect(task?.project).to(beNil())
            }
            
            it("throws an error if any of JSON elements except optional is missing.") {
                for key in taskJSON.keys where
                    key != "tags" &&
                    key != "due" &&
                    key != "priority" &&
                    key != "project" {
                        
                    var missingJSON = taskJSON
                    missingJSON[key] = nil
                    let task: TaskMapper? = try? decode(missingJSON)
                    
                    expect(task).to(beNil())
                }
            }
            
            it("ignores an extra element") {
                var extraJSON = taskJSON
                extraJSON["extraKey"] = "extra element"
                let task: TaskMapper? = try? decode(extraJSON)
                
                expect(task).notTo(beNil())
            }
        }
    }
}

/*

dateFormatter.dateFormat = "yyyy-MM-dd: HH:mm"

dueDate: NSDate? = nil,
tags: [String]? = nil,
priority: String? = nil

"description": "first task",
"id": "1ec9e89b-7dab-4246-9f05-6fd5e0cc1c81",
"project": "testproject",
"urgency": 8.00959,
"status": "pending",
"due": "Wed, 6 Jan 2016 20:06:47 +0000",
"tags": ["first tag", "second tag"],
"priority": "H"

*/