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
    
    init(metaObject: NameWithCountRepresentable, currentMeta: NameWithCountRepresentable) {
        name = metaObject.nameString
        
        if metaObject.nameString != currentMeta.nameString {
            accessoryType = false
        } else {
            accessoryType = true
        }
    }
}
