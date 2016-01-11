//
//  TaskDetailViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TaskDetailViewModel: TaskDetailViewModeling {
    
    // TaskDetailViewModel
    
    var name: Observable<String> {
        return _desc.asObservable()
    }
    
    var status: Observable<String> {
        return _status.asObservable()
    }
    
    var tagsText: Observable<String> {
        return _tagsText.asObservable()
    }
    
    var urgency: Observable<String> {
        return _urgency.asObservable()
    }
    
    var priority: Observable<String> {
        return _priority.asObservable()
    }
    
    // send after task deleting
    var popViewController: Observable<Bool> {
        return _popViewController.asObservable()
    }
    
    init(task: Task) {
        self.task = task
        
        _desc.onNext(task.name)
        _status.onNext(task.status)
        _tagsText.onNext(task.tags?.joinWithSeparator(", ") ?? "")
        _urgency.onNext("\(task.urgency)")
        _priority.onNext(task.priority ?? "No priority")
    }
    
    func deleteTask() {
        task.managedObjectContext?.performChanges {
            self.task.managedObjectContext?.deleteObject(self.task)
        }
        // TODO: Implement notification if deletion came in via network
        /*
            We can implement it with managed object observer
            or fetched result controller
        */
        _popViewController.onNext(true)
    }
    
    // MARK: Private
    
    private let task: Task
    
    private let _desc = BehaviorSubject<String>(value: "")
    private let _status = BehaviorSubject<String>(value: "")
    private let _tagsText = BehaviorSubject<String>(value: "")
    private let _urgency = BehaviorSubject<String>(value: "")
    private let _priority = BehaviorSubject<String>(value: "")
    private let _popViewController = BehaviorSubject<Bool>(value: false)
}
