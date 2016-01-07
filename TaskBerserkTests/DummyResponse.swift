//
//  DummyResponse.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
@testable import TaskBerserk

let dummyResponse: ResponseEntity = {
    let taskFirst = TaskEntity(
        description: "Task 1 description",
        id: "1",
        projectName: "default",
        urgency: 2.31,
        status: "waiting",
        tags: ["@computer", "online"]
    )
    
    let taskSecond = TaskEntity(
        description: "Task 2 description",
        id: "2",
        projectName: "shopping list",
        urgency: 1.25,
        status: "waiting",
        tags: ["@walk", "store"]
    )
//    TaskEntity(
//        description: "Task 1 description",
//        id: 1,
//        projectName: "default",
//        urgency: 2.31,
//        status: "waiting",
//        uuid: "b8d05cfe-8464-44ef-9d99-eb3e7809d337",
//        tags: ["@computer", "online"]
//    )
//    
//    let taskSecond = TaskEntity(
//        description: "Task 2 description",
//        id: 2,
//        projectName: "shopping list",
//        urgency: 1.25,
//        status: "waiting",
//        uuid: "b8d05cfe-8464-44ef-9d99-eb3e7809d338",
//        tags: ["@walk", "store"]
//    )
    return ResponseEntity(totalCount: 51, tasks: [taskFirst, taskSecond])
}()