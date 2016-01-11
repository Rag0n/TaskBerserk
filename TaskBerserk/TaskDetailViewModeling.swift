//
//  TaskDetailViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

protocol TaskDetailViewModeling {
    var desc: String { get }
    var status: String { get }
    var tagsText: String { get }
    var urgency: String { get }
    var priority: String { get }
}
