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
    private let taskGrab: TaskGrabbing
    private let disposeBag = DisposeBag()
    
    private let _cellModels = BehaviorSubject<[TaskTableViewCellModeling]>(value: [])
    var cellModels: Observable<[TaskTableViewCellModeling]> {
        return _cellModels.asObservable()
    }
    
    init(taskGrab: TaskGrabbing) {
        self.taskGrab = taskGrab
    }
    
    // Converting ResponseEntity into [TaskTableViewCellModeling]
    func receiveTasks() {
        taskGrab.grabTasks()
            .map { response in
                response.tasks.map {
                    TaskTableViewCellModel(task: $0) as TaskTableViewCellModeling
                }
            }
            // grabTasks returns response on the background thread
            .observeOn(MainScheduler.instance)
            .subscribeNext { cellModels in
                self._cellModels.onNext(cellModels)
            }
            .addDisposableTo(disposeBag)
    }
}
