//
//  TasksTableViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

import UIKit

class TasksTableViewModel: TasksTableViewModeling, DataProviderDelegate {
    
    typealias Object = Task

    var managedObjectContext: NSManagedObjectContext!
    var updates: Observable<[DataProviderUpdate<TaskTableViewCellModeling>]> {
        return _updates.asObservable()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }

    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskTableViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskTableViewCellModel(task: object)
    }
    
    func detailViewModelForIndexPath(indexPath: NSIndexPath) -> TaskDetailViewModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskDetailViewModel(task: object)
    }
    
    func addNewTask(task: TaskEntity) {
        managedObjectContext.performChanges {
            Task.insertIntoContext(self.managedObjectContext, taskEntity: task)
        }
    }
    
    init(project: ProjectEntity?, managedObject: NSManagedObjectContext?) {
//        self.project = project
        self.managedObjectContext = managedObject!
//        updateCellModels()
        setupDataProvider()
    }
    
    private typealias Data = FetchedResultsDataProvider<TasksTableViewModel>
//    private var dataSource: TableViewDataSource<TasksTableViewModel, Data, TaskTableViewCellModel>!
    
    
    private func setupDataProvider() {
        let request = Task.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        
        dataProvider.updatesSignal
            .map { updates in
                var transformedUpdate: [DataProviderUpdate<TaskTableViewCellModeling>]
                
                transformedUpdate = updates.map { update in
                    switch update {
                    case .Insert(let indexPath):
                        return (.Insert(indexPath))
                    case .Update(let indexPath, let object):
                        let cellViewModel = TaskTableViewCellModel(task: object) as TaskTableViewCellModeling
                        return (.Update(indexPath, cellViewModel))
                    case .Move(let indexPath, let newIndexPath):
                        return (.Move(indexPath, newIndexPath))
                    case .Delete(let indexPath):
                        return (.Delete(indexPath))
                    }
                }
                
                return transformedUpdate
            }
            .subscribeNext { updates in
                self._updates.onNext(updates)
            }
            .addDisposableTo(disposeBag)
        
        // TODO: Fix
//        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProvider, delegate: self)
    }
    
    
    
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TasksTableViewModel>!
    private let disposeBag = DisposeBag()
    private let _updates = BehaviorSubject<[DataProviderUpdate<TaskTableViewCellModeling>]>(value: [])
    
}


extension TasksTableViewModel: DataSourceDelegate {
    func cellIdentifierForObject(object: Task) -> String {
        return "TaskTableViewCell"
    }
}
