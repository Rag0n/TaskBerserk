//
//  MetaTableViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 12.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

protocol MetaTableViewModeling: ManagedObjectContextSettable {
    var updates: Observable<[DataProviderUpdate<MetaTableViewCellModeling>]> { get }
    
    func numberOfItemsInSection(section: Int) -> Int
    func viewModelForIndexPath(indexPath: NSIndexPath) -> MetaTableViewCellModeling
}
