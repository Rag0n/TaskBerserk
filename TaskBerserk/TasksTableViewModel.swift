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

    var managedObjectContext: NSManagedObjectContext!
    
    var cellModels: Observable<[TaskTableViewCellModeling]> {
        return _cellModels.asObservable()
    }
    
    init(project: ProjectEntity?) {
        self.project = project
//        updateCellModels()
        setupDataProvider()
    }
    
    private typealias Data = FetchedResultsDataProvider<TasksTableViewModel>
//    private var dataSource: TableViewDataSource<TasksTableViewModel, Data, TaskTableViewCellModel>!
    
    func setupDataProvider() {
        let request = Task.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        
        // TODO: Fix
//        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProvider, delegate: self)
    }
    
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private var project: ProjectEntity?
    private let _cellModels = BehaviorSubject<[TaskTableViewCellModeling]>(value: [])
    
    private func updateCellModels() {
        let updatedCellModels = project?.tasks.map { task in
            TaskTableViewCellModel(task: task) as TaskTableViewCellModeling
        }
        
        if let updatedCellModels = updatedCellModels {
            _cellModels.onNext(updatedCellModels)    
        }
    }
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