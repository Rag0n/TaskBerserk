//
//  ResponseEntitySpec.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import Himotoki
@testable import TaskBerserk

class ResponseEntitySpec: QuickSpec {
    override func spec() {
        let json: [String: AnyObject] = [
            "total_count": 95,
            "objects": [taskJSON, taskJSON]
        ]
        
        it("parses JSON data to create a new instance.") {
            let response: ResponseEntity? = try? decode(json)
            
            expect(response).notTo(beNil())
            expect(response?.totalCount) == 95
            expect(response?.tasks.count) == 2
        }
    }
}
