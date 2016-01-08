//
//  TasksTableViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

class TasksTableViewModel: TasksTableViewModeling {
    
    var cellModels: Observable<[TaskTableViewCellModeling]> {
        return _cellModels.asObservable()
    }
    
    init(project: ProjectEntity) {
        self.project = project
        updateCellModels()
    }
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private var project: ProjectEntity?
    private let _cellModels = BehaviorSubject<[TaskTableViewCellModeling]>(value: [])
    
    private func updateCellModels() {
        let updatedCellModels = project?.tasks.map { task in
            TaskTableViewCellModel(task: task) as TaskTableViewCellModeling
        }
        
        if let updatedCellModels = updatedCellModels {
            _cellModels.onNext(updatedCellModels)    
        }
    }
}
