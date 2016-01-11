//
//  TaskDetailViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class TaskDetailViewModel: TaskDetailViewModeling {
    var desc: String
    var status: String
    var tagsText: String
    var urgency: String
    var priority: String
    
    init(task: Task) {
        self.desc = task.desc
        self.status = task.status
        self.tagsText = task.tags?.joinWithSeparator(", ") ?? ""
        self.urgency = "\(task.urgency)"
        self.priority = task.priority ?? "No priority"
    }
}
