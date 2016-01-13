//
//  TasksTableViewControllerSpec.swift
//  TaskBerserk
//
//  Created by Александр on 07.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import TaskBerserk

//class TasksTableViewControllerSpec: QuickSpec {
//    // MARK: Mock
//    class MockViewModel: TasksTableViewModeling {
//        let cellModels:Observable<[TaskTableViewCellModeling]> = BehaviorSubject(value: [TaskTableViewCellModeling]())
//        var receiveTasksCallCount = 0
//        
//        func receiveTasks() {
//            receiveTasksCallCount += 1
//        }
//    }
//    
//    // MARK: Spec
//    override func spec() {
////        it("starts receiving tasks when the view is about to appear at the first time.") {
////            let viewModel = MockViewModel()
////            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: TasksTableViewController.self))
////            let vc = storyboard.instantiateViewControllerWithIdentifier("TasksTableViewController") as! TasksTableViewController
////            vc.viewModel = viewModel
////            
////            expect(viewModel.receiveTasksCallCount) == 0
////            vc.viewWillAppear(true)
////            expect(viewModel.receiveTasksCallCount) == 1
////            vc.viewWillAppear(true)
////            expect(viewModel.receiveTasksCallCount) == 1
////        }
//    }
//}
