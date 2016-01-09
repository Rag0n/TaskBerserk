//
//  TasksTableViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import RxSwift

protocol TasksTableViewModeling: ManagedObjectContextSettable {
    var cellModels: Observable<[TaskTableViewCellModeling]> { get }
}
