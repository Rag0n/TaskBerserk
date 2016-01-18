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
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling
    func numberOfItemsInSection(section: Int) -> Int
}
