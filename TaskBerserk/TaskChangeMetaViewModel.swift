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

class TaskChangeMetaViewModel: TaskChangeMetaViewModeling {
    var metaObject: MetaObject
    var managedObjectContext: NSManagedObjectContext!
    
    typealias ViewModel = TaskChangeMetaViewCellModeling
    typealias Object = NameWithCountRepresentable
    
    init(metaObject: MetaObject) {
        self.metaObject = metaObject
        setupDataProvider()
    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TaskChangeMetaViewModel>!
    private let disposeBag = DisposeBag()
    
    private func setupDataProvider() {
        let request: NSFetchRequest
        
        switch metaObject {
        case .ProjectType(_):
            request = Project.sortedFetchRequest
        case .TagType(_):
            request = Tag.sortedFetchRequest
        }
        
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { object in
            TaskChangeMetaViewCellModel(metaObject: object)
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
}
