//
//  TaskMapper.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Himotoki

struct TaskMapper {
    let name: String
    let id: String
    let status: String
    let urgency: Double
    
    let priority: String?
    let project: String?
    let tags: [String]?
    let dueDate: String?
}

// MARK: Decodable
extension TaskMapper: Decodable {
    static func decode(e: Extractor) throws -> TaskMapper {
        return try TaskMapper(
            name: e <| "description",
            id: e <| "id",
            status: e <| "status",
            urgency: e <| "urgency",
            priority: e <|? "priority",
            project: e <|? "project",
            tags: e <||? "tags",
            dueDate: e <|? "due")
    }
}
