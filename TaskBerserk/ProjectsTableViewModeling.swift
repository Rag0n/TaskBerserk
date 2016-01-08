//
//  ProjectsTableViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 07.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import RxSwift
import Foundation

protocol ProjectsTableViewModeling {
    var cellModels: Observable<[ProjectTableViewCellModeling]> { get }
    func updateTasks()
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TasksTableViewModeling
}