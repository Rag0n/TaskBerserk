//
//  NetworkSpec.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import Alamofire
@testable import TaskBerserk

class NetworkSpec: QuickSpec {
    override func spec() {
        var network: Network!
        let disposeBag = DisposeBag()
        
        describe("JSON") {
            
            it("eventually gets JSON data as specified with parameters.") {
                network = Network()
                var json: [String: AnyObject]? = nil
                let url = "https://httpbin.org/get"
                network.requestJSON(url, parameters: ["a": "b", "x": "y"])
                    .subscribeNext {
                        json = $0 as? [String: AnyObject]
                    }
                    .addDisposableTo(disposeBag)

                
                expect(json).toEventuallyNot(beNil(), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["a"] as? String)
                    .toEventually(equal("b"), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["x"] as? String)
                    .toEventually(equal("y"), timeout: 5)
            }
            
//            it("eventually gets an error if the network has a problem.") {
//                var error: NetworkError? = nil
//                let url = "https://notexitsting.server"
//                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//                // by default timeout is 60s, it is too long for tests
//                configuration.timeoutIntervalForRequest = 1 // seconds
//                configuration.timeoutIntervalForResource = 1
//                
//                network.requestJSON(url, parameters: ["a": "b", "x": "y"])
//                    .subscribeError {
//                        error = $0 as? NetworkError
//                    }
//                    .addDisposableTo(disposeBag)
//
//                expect(error).toEventuallyNot(beNil(), timeout: 4)
//                expect(error).toEventually(equal(NetworkError.NotReachedServer), timeout: 4)
//            }
        }
    }
}