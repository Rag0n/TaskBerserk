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
    
    var desc: Observable<String> {
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
        return _priority
    }
    
    init(task: Task) {
        _desc.onNext(task.desc)
        _status.onNext(task.status)
        _tagsText.onNext(task.tags?.joinWithSeparator(", ") ?? "")
        _urgency.onNext("\(task.urgency)")
        _priority.onNext(task.priority ?? "No priority")
    }
    
    func deleteTask() {
        print("delete")
    }
    
    // MARK: Private
    
    private let _desc = BehaviorSubject<String>(value: "")
    private let _status = BehaviorSubject<String>(value: "")
    private let _tagsText = BehaviorSubject<String>(value: "")
    private let _urgency = BehaviorSubject<String>(value: "")
    private let _priority = BehaviorSubject<String>(value: "")
}
