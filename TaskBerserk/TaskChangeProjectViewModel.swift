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
    var projectName: CustomStringConvertible
    var managedObjectContext: NSManagedObjectContext!
    let cellIdentifier = "TaskChangeProject"
    
    typealias ViewModel = TaskChangeMetaViewCellModeling
    typealias Object = CustomStringConvertible
    
    init(moc: NSManagedObjectContext, projectName: CustomStringConvertible) {
        self.projectName = projectName
        self.managedObjectContext = moc
        setupDataProvider()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: [self.projectName])
    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TaskChangeProjectViewModel>!
    private let disposeBag = DisposeBag()
    
    private let _popViewController = BehaviorSubject<Bool>(value: false)
    
    private func setupDataProvider() {
        let request = Project.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { [weak self] object in
            if let projectName = self?.projectName {
                return TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: [projectName])
            } else {
                return TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: nil)
            }
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
}
