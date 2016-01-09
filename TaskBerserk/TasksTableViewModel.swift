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

class TasksTableViewModel: TasksTableViewModeling {
    
    typealias Object = Task

    var managedObjectContext: NSManagedObjectContext!
    
    var cellModels: Observable<[TaskTableViewCellModeling]> {
        return _cellModels.asObservable()
    }
    
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }

    
    var updates: Observable<[DataProviderUpdate<TaskTableViewCellModeling>]> {
        return _updates.asObservable()
    }
    private let _updates = BehaviorSubject<[DataProviderUpdate<TaskTableViewCellModeling>]>(value: [])
//    func objectAtIndexPath(indexPath: NSIndexPath) -> Task {
//        return dataProvider.objectAtIndexPath(indexPath)
//    }
//    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskTableViewCellModeling {
        let object = dataProvider.objectAtIndexPath(indexPath)
        return TaskTableViewCellModel(task: object)
    }
    
    init(project: ProjectEntity?) {
        self.project = project
        
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
    private var project: ProjectEntity?
    private let _cellModels = BehaviorSubject<[TaskTableViewCellModeling]>(value: [])
    
//    private func updateCellModels() {
//        let updatedCellModels = project?.tasks.map { task in
//            TaskTableViewCellModel(task: task) as TaskTableViewCellModeling
//        }
//        
//        if let updatedCellModels = updatedCellModels {
//            _cellModels.onNext(updatedCellModels)    
//        }
//    }
}

extension TasksTableViewModel: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Task>]?) {
//        dataSource.processUpdates(updates)
        print("data provider did update")
    }
}

extension TasksTableViewModel: DataSourceDelegate {
    func cellIdentifierForObject(object: Task) -> String {
        return "TaskTableViewCell"
    }
}