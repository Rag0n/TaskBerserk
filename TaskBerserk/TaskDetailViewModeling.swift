//
//  TaskDetailViewModeling.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskDetailViewModeling {
    var desc: Observable<String> { get }
    var status: Observable<String> { get }
    var tagsText: Observable<String> { get }
    var urgency: Observable<String> { get }
    var priority: Observable<String> { get }

    var popViewController: Observable<Bool> { get }
    
    func deleteTask()
}
