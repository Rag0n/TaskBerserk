//
//  ResponseEntity.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Himotoki

class ResponseEntity {
    let totalCount: Int64
    let tasks: [TaskMapper]
    
    init(totalCount: Int64, tasks: [TaskMapper]) {
        self.totalCount = totalCount
        self.tasks = tasks
    }
}

// MARK: Decodable
extension ResponseEntity: Decodable {
    static func decode(e: Extractor) throws -> ResponseEntity {
        return try ResponseEntity(
            totalCount: e <| ["meta", "total_count"],
            tasks: e <|| "objects")
    }
}

/*

{
    "meta":{
    "limit":100,
    "next":null,
    "offset":0,
    "previous":null,
    "total_count":5
},
    "objects":[
        {},
        {},
        {},
        {},
        {}
    ]
}

*/
