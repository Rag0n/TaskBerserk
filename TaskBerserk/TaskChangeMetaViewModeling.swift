//
//  TaskChangeMetaViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskChangeMetaViewModeling: ManagedObjectContextSettable {
    var metaObject: MetaObject { get }
    var cellIdentifier: String { get }
    
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling
    func numberOfItemsInSection(section: Int) -> Int
}

enum MetaObject {
    case ProjectType(Project)
    case TagType([Tag]?)
}
