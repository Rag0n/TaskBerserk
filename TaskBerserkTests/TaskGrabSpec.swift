//
//  TaskGrabSpec.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import TaskBerserk

class TaskGrabSpec: QuickSpec {
    // MARK: stubs
    // emulating an asynchronous network response
    class GoodStubNetwork: Networking {
        func requestJSON(url: String, parameters: [String: AnyObject]?, headers: [String: String]?) -> Observable<AnyObject> {
            var taskJSONFirst = taskJSON
            taskJSONFirst["id"] = "0"
            var taskJSONSecond = taskJSON
            taskJSONSecond["id"] = "1"
            
            let json: [String: AnyObject] = [
                "meta": ["total_count": 95],
                "objects": [taskJSONFirst, taskJSONSecond]
            ]
            
            return Observable.create { observer -> Disposable in
                observer.onNext(json)
                observer.onCompleted()
                return NopDisposable.instance
            }
            .observeOn(SerialDispatchQueueScheduler.init(globalConcurrentQueueQOS: DispatchQueueSchedulerQOS.Background))
        }
    }
    
    class BadStubNetwork: Networking {
        func requestJSON(url: String, parameters: [String: AnyObject]?, headers: [String: String]?) -> Observable<AnyObject> {
            let json = [String: AnyObject]()
            
            return Observable.create { observer -> Disposable in
                observer.onNext(json)
                observer.onCompleted()
                return NopDisposable.instance
            }
            .observeOn(SerialDispatchQueueScheduler.init(globalConcurrentQueueQOS: DispatchQueueSchedulerQOS.Background))
        }
    }
    
    class ErrorStubNetwork: Networking {
        func requestJSON(url: String, parameters: [String: AnyObject]?, headers: [String: String]?) -> Observable<AnyObject> {
            return Observable.create { observer -> Disposable in
                observer.onError(NetworkError.NotConnectedToInternet)
                return NopDisposable.instance
            }
            .observeOn(SerialDispatchQueueScheduler.init(globalConcurrentQueueQOS: DispatchQueueSchedulerQOS.Background))
        }
    }
    
    // MARK: Spec
    override func spec() {
        let disposeBag = DisposeBag()
        
        it("returns task if the network works correctly") {
            var response: ResponseEntity?
            let grab = TaskGrab(network: GoodStubNetwork())
            
            grab.grabTasks()
                .subscribeNext {
                    response = $0
                }
                .addDisposableTo(disposeBag)
            
            expect(response).toEventuallyNot(beNil())
            expect(response?.totalCount) == 95
            expect(response?.tasks.count) == 2
            expect(response?.tasks[0].id) == "0"
            expect(response?.tasks[1].id) == "1"
        }
        
        it("returns an error if the network returns incorrect data") {
            var error: NetworkError?
            let grab = TaskGrab(network: BadStubNetwork())
            
            grab.grabTasks()
                .subscribeError {
                    error = $0 as? NetworkError
                }
                .addDisposableTo(disposeBag)
            
            expect(error).toEventuallyNot(beNil())
            expect(error).toEventually(equal(NetworkError.IncorrectDataReturned))
        }
        
        it("passes the error sent by the network") {
            var error: NetworkError?
            let grab = TaskGrab(network: ErrorStubNetwork())
            
            grab.grabTasks()
                .subscribeError {
                    error = $0 as? NetworkError
                }
                .addDisposableTo(disposeBag)
            
            expect(error).toEventuallyNot(beNil())
            expect(error).toEventually(equal(NetworkError.NotConnectedToInternet))
        }
    }
}
