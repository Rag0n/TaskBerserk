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
import CoreData

class TaskDetailViewModel: TaskDetailViewModeling {
    
    var managedObjectContext: NSManagedObjectContext!
    
    let changeProjectIdentifier = "ChangeProject"
    let changeTagsIdentifier = "ChangeTags"
    
    // TaskDetailViewModel
    
    var name: Observable<String> {
        return _name.asObservable()
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
    
    var project: Observable<String> {
        return _project.asObservable()
    }
    
    // send after task deleting
    var popViewController: Observable<Bool> {
        return _popViewController.asObservable()
    }
    
    init(task: Task) {
        self.task = task
        
        _name.onNext(task.name)
        _status.onNext(task.status)
        _urgency.onNext("\(task.urgency)")
        _priority.onNext(task.priority ?? "No priority")
        
        var tagsText = ""
        if let tags = task.tags {
            for tag in tags {
                tagsText += "\(tag)"
            }
        }
        _tagsText.onNext(tagsText)
        
        _project.onNext("\(task.project)")
        
    }
    
    func changeTaskName(newName: String) {
        // TODO: Иначе послать сигнал onNext содержащий сообщение ошибки, view покажет Alert
        if !newName.isEmpty {
            _name.onNext(newName)
        }
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
    
    func cancelChanges() {
        _popViewController.onNext(true)
    }
    
    func saveChanges() {
        do {
            let newName = try _name.value()
            managedObjectContext.performChanges {
                self.task.changeName(newName)
            }
        } catch {
            fatalError("Something went wrong while saving task")
        }
        
        _popViewController.onNext(true)
    }
    
    func viewModelForIdentifier(identifier: String) -> TaskChangeMetaViewModeling {
        switch identifier {
        case changeProjectIdentifier:
            return TaskChangeMetaViewModel(managedObject: managedObjectContext, metaObject: MetaObject.ProjectType(task.project), task: task)
        case changeTagsIdentifier:
            if let tags = task.tags {
                return TaskChangeMetaViewModel(managedObject: managedObjectContext, metaObject: MetaObject.TagType(Array(tags)), task: task)
            } else {
                return TaskChangeMetaViewModel(managedObject: managedObjectContext, metaObject: MetaObject.TagType(nil), task: task)
            }
        default:
            fatalError("Wrong segue identifier")
        }
    }
    
    // MARK: Private
    
    private let task: Task
    
    private let _name = BehaviorSubject<String>(value: "")
    private let _status = BehaviorSubject<String>(value: "")
    private let _tagsText = BehaviorSubject<String>(value: "")
    private let _urgency = BehaviorSubject<String>(value: "")
    private let _priority = BehaviorSubject<String>(value: "")
    private let _project = BehaviorSubject<String>(value: "")
    private let _popViewController = BehaviorSubject<Bool>(value: false)
}
