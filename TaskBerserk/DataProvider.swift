//
//  DataProvider.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

protocol DataProvider: class {
    typealias Object
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object
    func numberOfItemsInSection(section: Int) -> Int
}

protocol DataProviderDelegate: class {
    typealias Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object> {
    case Insert(NSIndexPath)
    case Update(NSIndexPath, Object)
    case Move(NSIndexPath, NSIndexPath)
    case Delete(NSIndexPath)
}
