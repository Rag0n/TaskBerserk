//
//  FetchedResultsDataProvider.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

// encapsulates FetchedResultsController delegates methods
class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    typealias Object = Delegate.Object
    typealias ViewModel = Delegate.ViewModel
    var updatesSignal = BehaviorSubject<[DataProviderUpdate<ViewModel>]>(value: [])
    
    init(fetchedResultsController: NSFetchedResultsController, delegate: Delegate, transformerFunc: (Object) -> ViewModel) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        self.transformerFunc = transformerFunc
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    // MARK: DataProvider
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        guard let result = fetchedResultsController.objectAtIndexPath(indexPath) as? Object else {
            fatalError("Unexpected object at \(indexPath)")
        }
        return result
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard let sec = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sec.numberOfObjects
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        updates = []
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            guard let indexPath = newIndexPath else {
                fatalError("Index path should be not nil")
            }
            updates.append(.Insert(indexPath))
        case .Move:
            guard let oldIndexPath = indexPath,
                newIndexPath = newIndexPath else {
                    fatalError("Index path should be not nil")
            }
            updates.append(.Move(oldIndexPath, newIndexPath))
        case .Update:
            guard let indexPath = indexPath else {
                fatalError("Index path should be not nil")
            }
            let object = objectAtIndexPath(indexPath)
            let viewModel = transformerFunc(object)
            updates.append(.Update(indexPath, viewModel))
        case .Delete:
            guard let indexPath = indexPath else {
                fatalError("Index path should be not nil")
            }
            updates.append(.Delete(indexPath))
        }
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        updatesSignal.onNext(updates)
    }
    
    // MARK: Private
    private let fetchedResultsController: NSFetchedResultsController
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<ViewModel>] = []
    private var transformerFunc: (Object) -> ViewModel
    
}
