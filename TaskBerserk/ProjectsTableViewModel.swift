//
//  ProjectsTableViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 07.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import RxSwift

class ProjectsTableViewModel: ProjectsTableViewModeling {
    private let disposeBag = DisposeBag()
    private let _cellModels = BehaviorSubject<[ProjectTableViewCellModeling]>(value: [])
    
    var cellModels: Observable<[ProjectTableViewCellModeling]> {
        return _cellModels.asObservable()
    }
    
    init() {
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
}
