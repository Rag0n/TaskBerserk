//
//  TaskEntitySpec.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import Himotoki
@testable import TaskBerserk

class TaskEntitySpec: QuickSpec {
    override func spec() {
        context("parses JSON data") {
            it("to create a new instance") {
                let task: TaskEntity? = try? decode(taskJSON)
                
                expect(task).notTo(beNil())
                expect(task?.description) == "Task description"
                expect(task?.id) == 123
                expect(task?.project?.name) == "Shopping list"
                expect(task?.urgency) == 2.31
                expect(task?.status) == "waiting"
                expect(task?.uuid) == "b8d05cfe-8464-44ef-9d99-eb3e7809d337"
                expect(task?.tags) == ["first tag", "second tag"]
                expect(task?.depends) == 251
                expect(task?.priority) == "H"
                expect(task?.dueDate) == "Apr 1, 2015, 8:53 AM"
            }
            
            it("to create a new instance when optional data is misssed") {
                var missingJSON = taskJSON
                missingJSON["due"] = nil
                missingJSON["priority"] = nil
                missingJSON["depends"] = nil
                missingJSON["tags"] = nil
                let task: TaskEntity? = try? decode(missingJSON)
                
                expect(task).notTo(beNil())
                expect(task?.dueDate).to(beNil())
                expect(task?.depends).to(beNil())
                expect(task?.tags).to(beNil())
            }
            
            it("throws an error if any of JSON elements except optional is missing.") {
                for key in taskJSON.keys where
                    key != "tags" &&
                    key != "due" &&
                    key != "depends" &&
                    key != "priority" {
                        
                    var missingJSON = taskJSON
                    missingJSON[key] = nil
                    let task: TaskEntity? = try? decode(missingJSON)
                    
                    expect(task).to(beNil())
                }
            }
            
            it("ignores an extra element") {
                var extraJSON = taskJSON
                extraJSON["extraKey"] = "extra element"
                let task: TaskEntity? = try? decode(extraJSON)
                
                expect(task).notTo(beNil())
            }
        }
    }
}

/*

dateFormatter.dateFormat = "yyyy-MM-dd: HH:mm"

dueDate: NSDate? = nil,
tags: [String]? = nil,
depends: UInt64? = nil,
priority: String? = nil

let taskJSON: [String: AnyObject] = [
"description": "Task description",
"id": 123,
"project": "Shopping list",
"urgency": 2.31,
"status": "waiting",
"uuid": "b8d05cfe-8464-44ef-9d99-eb3e7809d337",
"due": "Apr 1, 2015, 8:53 AM",
"tags": ["first tag", "second tag"],
"depends": 251,
"priority": "H"
]

*/