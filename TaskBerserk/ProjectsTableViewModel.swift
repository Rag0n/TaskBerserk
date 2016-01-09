//
//  ProjectsTableViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 07.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//
import Foundation
import RxSwift
import CoreData

class ProjectsTableViewModel: ProjectsTableViewModeling {
    private let taskGrab: TaskGrabbing
    private let disposeBag = DisposeBag()
    private let _cellModels = BehaviorSubject<[ProjectTableViewCellModeling]>(value: [])
    
    var cellModels: Observable<[ProjectTableViewCellModeling]> {
        return _cellModels.asObservable()
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    init(taskGrab: TaskGrabbing) {
        self.taskGrab = taskGrab
        bindCellModelsToProjects()
    }
    
    private func bindCellModelsToProjects() {
        ProjectEntity.projects
            .map { projects in
                projects.map { project in
                    ProjectTableViewCellModel(project: project) as ProjectTableViewCellModeling
                }
            }
            .subscribeNext { cellModels in
                self._cellModels.onNext(cellModels)
            }
            .addDisposableTo(disposeBag)
    }
    
    func updateTasks() {
        taskGrab.grabTasks()
//            .flatMap { _ in
//                ProjectEntity.projects
//            }
//            .map { projects in
//                projects.map { project in
//                    ProjectTableViewCellModel(project: project) as ProjectTableViewCellModeling
//                }
//            }
            // grabTasks returns response on the background thread
//            .observeOn(MainScheduler.instance)
//            .subscribeNext { cellModels in
//                self._cellModels.onNext(cellModels)
//            }
            .subscribeNext { response in
                print("\(response.totalCount) tasks updated")
            }
            .addDisposableTo(disposeBag)
        
    }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TasksTableViewModeling {
        let project = ProjectEntity.projectsArray[indexPath.row]
        return TasksTableViewModel(project: project, managedObject: nil)
    }
}
