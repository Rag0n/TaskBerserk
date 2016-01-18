//
//  TaskChangeTagsViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskChangeTagsViewModeling: ManagedObjectContextSettable {
    var metaObject: MetaObject { get }
    var cellIdentifier: String { get }
    var metaObjectDescription: String { get }
    
    func cancelChanges()
    func saveChanges()
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling
    func changeCurrentMetaObject(indexPath: NSIndexPath)
    func addNewMetaObject(name: String?)
    func numberOfItemsInSection(section: Int) -> Int
    
    var popViewController: Observable<Bool> { get }
}

enum MetaObject {
    case ProjectType(Project)
    case TagType([Tag]?)
}
