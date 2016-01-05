//
//  TasksTableViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class TasksTableViewModel: TasksTableViewModeling {
    private let taskGrab: TaskGrabbing
    
    init(taskGrab: TaskGrabbing) {
        self.taskGrab = taskGrab
    }
}
