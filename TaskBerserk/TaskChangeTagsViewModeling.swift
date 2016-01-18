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
    var tagNames: [String] { get }
    var cellIdentifier: String { get }
  
    func viewModelForIndexPath(indexPath: NSIndexPath) -> TaskChangeMetaViewCellModeling
    func numberOfItemsInSection(section: Int) -> Int
    
    func changeCurrentTag(indexPath: NSIndexPath)
    func addNewTag(newTagName: String?)
    
    var tableViewShouldUpdates: Observable<Bool> { get }
}
