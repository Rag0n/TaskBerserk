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
@testable import TaskBerserk

class NetworkSpec: QuickSpec {
    override func spec() {
        var network: Network!
        let disposeBag = DisposeBag()
        beforeEach {
            network = Network()
        }
        
        describe("JSON") {
            it("eventually gets JSON data as specified with parameters.") {
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
        }
    }
}