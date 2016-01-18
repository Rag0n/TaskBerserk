//
//  TaskChangeProjectViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 18.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class TaskChangeProjectViewModel: TaskChangeProjectViewModeling, DataProviderDelegate {
    private(set) var projectName: String
    // used to reload only this path in tableViewController
    var currentProjectIndexPath: NSIndexPath {
        return NSIndexPath(forRow: currentProjectPosition, inSection: 0)
    }
    var managedObjectContext: NSManagedObjectContext!
    let cellIdentifier = "TaskChangeProject"
    
    typealias ViewModel = TaskChangeMetaViewCellModeling
    typealias Object = NameWithCountRepresentable
    
    init(moc: NSManagedObjectContext, projectName: String) {
        self.projectName = projectName
        self.managedObjectContext = moc
        currentProjectPosition = 0
        setupDataProvider()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        if object.nameString == projectName {
            currentProjectPosition = indexPath.row
        }
        return TaskChangeMetaViewCellModel(metaObject: object.nameString, currentMetaObjects: [self.projectName])
    }
    
    func changeCurrentProject(indexPath: NSIndexPath) {
        let newProjectName = dataProvider.objectAtIndexPath(indexPath)
        projectName = newProjectName.nameString
    }
    
    func addNewProject(newProjectName: String?) {
        projectName = newProjectName ?? projectName
    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TaskChangeProjectViewModel>!
    private let disposeBag = DisposeBag()
    private var currentProjectPosition: Int
    
    private func setupDataProvider() {
        let request = Project.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { [weak self] object in
            if let projectName = self?.projectName {
                return TaskChangeMetaViewCellModel(metaObject: object.nameString, currentMetaObjects: [projectName])
            } else {
                return TaskChangeMetaViewCellModel(metaObject: object.nameString, currentMetaObjects: nil)
            }
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
}
