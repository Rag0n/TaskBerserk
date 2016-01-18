//
//  TaskChangeProjectViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 18.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskChangeProjectViewModeling: ManagedObjectContextSettable {
    var projectName: String { get }
    var cellIdentifier: String { get }
    var currentProjectIndexPath: NSIndexPath { get }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling
    func numberOfItemsInSection(section: Int) -> Int
    
    func changeCurrentProject(indexPath: NSIndexPath)
    func addNewProject(newProjectName: String?)
}
