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
    
    init(managedObject: NSManagedObjectContext, metaObject: MetaObject) {
        self.metaObject = metaObject
        self.managedObjectContext = managedObject
        setupDataProvider()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: currentMetaObjects)
    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TaskChangeMetaViewModel>!
    private let disposeBag = DisposeBag()
    private var currentMetaObjects: [NameWithCountRepresentable]?
    
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
