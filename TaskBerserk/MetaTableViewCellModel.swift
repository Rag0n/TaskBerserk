//
//  MetaTableViewCellModel.swift
//  TaskBerserk
//
//  Created by Александр on 12.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

class MetaTableViewCellModel: MetaTableViewCellModeling {
    let name: String
    let count: String
    
    init(object: NameWithCountRepresentable) {
        name = object.nameString
        count = object.countString
    }
}
