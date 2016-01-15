//
//  DummyResponse.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
@testable import TaskBerserk

let dummyResponse: ResponseMapper = {
    let taskFirst = TaskMapper(
        name: "Task 1 description",
        id: "1",
        status: "waiting",
        urgency: 2.31,
        priority: nil,
        project: "default",
        tags: ["@computer", "online"],
        dueDate: nil
    )
    
    let taskSecond = TaskMapper(
        name: "Task 2 description",
        id: "2",
        status: "waiting",
        urgency: 1.25,
        priority: nil,
        project: "shopping list",
        tags: ["@walk", "store"],
        dueDate: nil
    )
    
    return ResponseMapper(totalCount: 51, tasks: [taskFirst, taskSecond])
}()