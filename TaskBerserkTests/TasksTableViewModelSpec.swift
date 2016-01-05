//
//  TasksTableViewModelSpec.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import Himotoki
import RxSwift
@testable import TaskBerserk

class TasksTableViewModelSpec: QuickSpec {
    // MARK: Stub
    class StubTaskGrab: TaskGrabbing {
        func grabTasks() -> Observable<ResponseEntity> {
            return Observable.create { observer in
                observer.onNext(dummyResponse)
                observer.onCompleted()
                return NopDisposable.instance
            }
            .observeOn(SerialDispatchQueueScheduler.init(globalConcurrentQueueQOS:
                DispatchQueueSchedulerQOS.Background))
        }
    }
    
    // MARK: Spec
    override func spec() {
        var viewModel: TasksTableViewModel!
        let disposeBag = DisposeBag()
        
        beforeEach {
            viewModel = TasksTableViewModel(taskGrab: StubTaskGrab())
        }
        
        it("sets cellmodels after search") {
            var cellModels: [TaskTableViewCellModeling]?
            viewModel.cellModels
                .subscribeNext {
                    cellModels = $0
                }
                .addDisposableTo(disposeBag)
            
            viewModel.receiveTasks()
            
            expect(cellModels).toEventuallyNot(beNil())
            expect(cellModels?.count).toEventually(equal(2))
        }
        
        it("sets cellModels propery on the main thread") {
            var onMainThread = false
            
            viewModel.cellModels
                .subscribeNext { _ in
                    onMainThread = NSThread.isMainThread()
                }
                .addDisposableTo(disposeBag)
            
            expect(onMainThread).toEventually(beTrue())
        }
    }
}
