//
//  ProjectTableViewCellModel.swift
//  TaskBerserk
//
//  Created by Александр on 07.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class ProjectTableViewCellModel: ProjectTableViewCellModeling {
    let projectName: String
    let taskCount: String
    
    init(project: ProjectEntity) {
        projectName = project.name
        taskCount = "\(project.tasks.count) left"
    }
}
