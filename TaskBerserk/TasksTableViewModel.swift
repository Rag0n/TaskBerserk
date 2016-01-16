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

class TasksTableViewModel: TasksTableViewModeling, DataProviderDelegate {
    
    typealias Object = Task
    typealias ViewModel = TaskTableViewCellModeling

    var managedObjectContext: NSManagedObjectContext!
    private var taskImporter: Importing
    
    var updates: Observable<[DataProviderUpdate<TaskTableViewCellModeling>]> {
        return dataProvider.updatesSignal
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
        let detailViewModel = TaskDetailViewModel(task: object)
        detailViewModel.managedObjectContext = managedObjectContext
        return detailViewModel
    }
    
    func addNewTask(taskName: String?) {
        print("Implement me pls")
        taskImporter.importTasks()
    }
    
//    func addNewTask(task: TaskMapper) {
//        managedObjectContext.performChanges {
//            Task.insertIntoContext(self.managedObjectContext, TaskMapper: task)
//        }
//    }
    
    init(managedObject: NSManagedObjectContext, taskImporter: Importing) {
        self.managedObjectContext = managedObject
        self.taskImporter = taskImporter
        setupDataProvider()
    }
    
    
    private func setupDataProvider() {
        let request = Task.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { object in
            TaskTableViewCellModel(task: object)
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }
    
    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<TasksTableViewModel>!
    private let disposeBag = DisposeBag()
    
}
