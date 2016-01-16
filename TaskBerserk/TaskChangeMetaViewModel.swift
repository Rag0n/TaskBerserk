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
    
    typealias ViewModel = TaskChangeMetaViewCellModeling
    typealias Object = NameWithCountRepresentable
    
    init(managedObject: NSManagedObjectContext, metaObject: MetaObject) {
        self.metaObject = metaObject
        self.managedObjectContext = managedObject
        setupDataProvider()
    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TaskChangeMetaViewModel>!
    private let disposeBag = DisposeBag()
    
    private func setupDataProvider() {
        let request: NSFetchRequest
        let currentMetaObjects: [NameWithCountRepresentable]?
        
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
        
        let transformerFunc: (Object) -> ViewModel = { object in
            TaskChangeMetaViewCellModel(metaObject: object, currentMetaObjects: currentMetaObjects)
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
}
