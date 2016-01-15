//
//  TasksTableViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import RxSwift
import Foundation

protocol TasksTableViewModeling: ManagedObjectContextSettable {
    var updates: Observable<[DataProviderUpdate<TaskTableViewCellModeling>]> { get }
    
    func numberOfItemsInSection(section: Int) -> Int
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskTableViewCellModeling
    func detailViewModelForIndexPath(indexPath: NSIndexPath) -> TaskDetailViewModeling
    func addNewTask(task: TaskMapper)
}
