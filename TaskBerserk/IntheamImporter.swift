//
//  IntheamImporter.swift
//  TaskBerserk
//
//  Created by Александр on 15.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class IntheamImporter: Importing {
    var managedObjectContext: NSManagedObjectContext!
    var webService: TaskWebService
    
    init(context: NSManagedObjectContext, webService: TaskWebService) {
        self.managedObjectContext = context
        self.webService = webService
    }
    
    func importTasks() {
        webService.fetchAllTask()
            .subscribeNext { response in
                for task in response.tasks {
                    self.managedObjectContext.performChanges {
                        Task.updateOrCreateTask(self.managedObjectContext, name: task.name, status: task.status, project: task.project, id: task.id, priority: task.priority, dueDate: task.dueDate, urgency: task.urgency, tags: task.tags)
                        }
                }
                
            }
            .addDisposableTo(disposeBag)
    }
    
    private var disposeBag = DisposeBag()
}
