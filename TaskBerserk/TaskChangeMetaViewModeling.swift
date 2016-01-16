//
//  TaskChangeMetaViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskChangeMetaViewModeling: ManagedObjectContextSettable, DataProviderDelegate {
    var metaObject: MetaObject { get }
}

enum MetaObject {
    case ProjectType(Project)
    case TagType(Tag)
}
