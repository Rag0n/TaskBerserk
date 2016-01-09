//
//  TaskTableViewCellModel.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class TaskTableViewCellModel: TaskTableViewCellModeling {
    let description: String
    let status: String
    let tagsText: String
    
    init(task: Task) {
        self.description = task.desc
        self.status = task.status
        self.tagsText = task.tags?.joinWithSeparator(", ") ?? ""
    }
}
