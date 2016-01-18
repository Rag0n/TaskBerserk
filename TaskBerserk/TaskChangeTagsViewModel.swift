//
//  TaskChangeTagsViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class TaskChangeTagsViewModel: TaskChangeTagsViewModeling, DataProviderDelegate {
    private(set) var tagNames: [String]
    var managedObjectContext: NSManagedObjectContext!
    let cellIdentifier = "TaskChangeTags"
    
    typealias ViewModel = TaskChangeMetaViewCellModeling
    typealias Object = NameWithCountRepresentable
    
    init(moc: NSManagedObjectContext, tags: Set<Tag>?) {
        if let tags = tags {
            tagNames = tags.map { $0.name }
        } else {
            tagNames = [String]()
        }
        self.managedObjectContext = moc
        setupDataProvider()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskChangeMetaViewCellModel(metaObject: object.nameString, currentMetaObjects: tagNames)
    }
    
//    func changeCurrentProject(indexPath: NSIndexPath) {
//        let newProjectName = dataProvider.objectAtIndexPath(indexPath)
//        projectName = newProjectName.nameString
//    }
//    
//    func addNewProject(newProjectName: String?) {
//        projectName = newProjectName ?? projectName
//    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TaskChangeTagsViewModel>!
    private let disposeBag = DisposeBag()
    
    private func setupDataProvider() {
        let request = Tag.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { [weak self] object in
            return TaskChangeMetaViewCellModel(metaObject: object.nameString, currentMetaObjects: self?.tagNames)
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
    
//    func changeCurrentMetaObject(indexPath: NSIndexPath) {
//        let object = dataProvider.objectAtIndexPath(indexPath)
//        switch metaObject {
//        case .ProjectType(_):
//            let newProject = object as! Project
//            currentMetaObjects = [newProject]
//        case .TagType(let tags):
//            let newTag = object as! Tag
//            guard var newTags = tags else {
//                currentMetaObjects = [newTag]
//                return
//            }
//            
//            if let index = newTags.indexOf(newTag) {
//                newTags.removeAtIndex(index)
//            } else {
//                newTags.append(newTag)
//            }
//
//            currentMetaObjects = newTags
//        }
//    }
//    
//    func addNewMetaObject(name: String?) {
//        guard let name = name else {
//            return
//        }
//        managedObjectContext.performChanges {
//            switch self.metaObject {
//            case .ProjectType(_):
//                self.task.changeProject(name, moc: self.managedObjectContext)
//            case .TagType(_):
//                self.task.addTags([name])
//            }
//        }
//        
//        _popViewController.onNext(true)
//    }
//    
//    func cancelChanges() {
//        _popViewController.onNext(true)
//    }
//    
//    func saveChanges() {
//        guard let currentMetaObjects = currentMetaObjects else {
//            return
//        }
//        let metaNames = currentMetaObjects.map { $0.nameString }
//        
//        managedObjectContext.performChanges {
//            switch self.metaObject {
//            case .ProjectType(_):
//                let newProjectName = metaNames[0]
//                self.task.changeProject(newProjectName, moc: self.managedObjectContext)
//            case .TagType(_):
//                self.task.changeTags(metaNames, moc: self.managedObjectContext)
//            }
//        }
//        
//        _popViewController.onNext(true)
//    }
//    
//    var popViewController: Observable<Bool> {
//        return _popViewController.asObservable()
//    }
//    
//    // use this in Alert Controller
//    var metaObjectDescription: String {
//        switch metaObject {
//        case .ProjectType(_):
//            return "project"
//        case .TagType(_):
//            return "tag"
//        }
//    }
//    
//    // MARK: Private
//    private let task: Task
//    private var dataProvider: FetchedResultsDataProvider<TaskChangeTagsViewModel>!
//    private let disposeBag = DisposeBag()
//    private var currentMetaObjects: [NameWithCountRepresentable]?
//    
//    private let _popViewController = BehaviorSubject<Bool>(value: false)
}
