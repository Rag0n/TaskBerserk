//
//  TaskChangeMetaViewCellModel.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class TaskChangeMetaViewCellModel: TaskChangeMetaViewCellModeling {
    var name: String
    var accessoryType: Bool
    
    init(metaObject: String, currentMetaObjects: [String]?) {
        name = metaObject
        
        // check if current meta objects(tags or project) contains current object from database
        if let currentMetaObjects = currentMetaObjects {
            accessoryType = currentMetaObjects.filter({ $0 == metaObject }).count > 0
        } else {
            accessoryType = false
        }
    }
}
