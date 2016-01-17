//
//  TaskChangeMetaViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class TaskChangeMetaViewModel: TaskChangeMetaViewModeling, DataProviderDelegate {
    var metaObject: MetaObject
    var managedObjectContext: NSManagedObjectContext!
    let cellIdentifier = "TaskChangeMeta"
    
    typealias ViewModel = TaskChangeMetaViewCellModeling
    typealias Object = NameWithCountRepresentable
    
    init(managedObject: NSManagedObjectContext, metaObject: MetaObject, task: Task) {
        self.metaObject = metaObject
        self.managedObjectContext = managedObject
        self.task = task
        setupDataProvider()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: currentMetaObjects)
    }
    
    func changeCurrentMetaObject(indexPath: NSIndexPath) {
        let object = dataProvider.objectAtIndexPath(indexPath)
        switch metaObject {
        case .ProjectType(_):
            let newProject = object as! Project
            currentMetaObjects = [newProject]
        case .TagType(let tags):
            let newTag = object as! Tag
            guard var newTags = tags else {
                currentMetaObjects = [newTag]
                return
            }
            
            if let index = newTags.indexOf(newTag) {
                newTags.removeAtIndex(index)
            } else {
                newTags.append(newTag)
            }

            currentMetaObjects = newTags
        }
    }
    
    func addNewMetaObject(name: String?) {
        guard let name = name else {
            return
        }
        managedObjectContext.performChanges {
            switch self.metaObject {
            case .ProjectType(_):
                self.task.changeProject(name, moc: self.managedObjectContext)
            case .TagType(_):
                self.task.addTags([name])
            }
        }
        
        _popViewController.onNext(true)
    }
    
    func cancelChanges() {
        _popViewController.onNext(true)
    }
    
    func saveChanges() {
        guard let currentMetaObjects = currentMetaObjects else {
            return
        }
        let metaNames = currentMetaObjects.map { $0.nameString }
        
        managedObjectContext.performChanges {
            switch self.metaObject {
            case .ProjectType(_):
                let newProjectName = metaNames[0]
                self.task.changeProject(newProjectName, moc: self.managedObjectContext)
            case .TagType(_):
                self.task.changeTags(metaNames, moc: self.managedObjectContext)
            }
        }
        
        _popViewController.onNext(true)
    }
    
    var popViewController: Observable<Bool> {
        return _popViewController.asObservable()
    }
    
    // use this in Alert Controller
    var metaObjectDescription: String {
        switch metaObject {
        case .ProjectType(_):
            return "project"
        case .TagType(_):
            return "tag"
        }
    }
    
    // MARK: Private
    private let task: Task
    private var dataProvider: FetchedResultsDataProvider<TaskChangeMetaViewModel>!
    private let disposeBag = DisposeBag()
    private var currentMetaObjects: [NameWithCountRepresentable]?
    
    private let _popViewController = BehaviorSubject<Bool>(value: false)
    
    private func setupDataProvider() {
        let request: NSFetchRequest
        
        switch metaObject {
        case .ProjectType(let project):
            request = Project.sortedFetchRequest
            currentMetaObjects = [project]
        case .TagType(let tags):
            request = Tag.sortedFetchRequest
            currentMetaObjects = tags
        }
        
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { [weak self] object in
            TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: self?.currentMetaObjects)
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
}
