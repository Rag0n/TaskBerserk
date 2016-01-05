//
//  TaskEntity.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Himotoki

class TaskEntity {
    let description: String
    let depends: UInt64?
    let id: UInt64
    let priority: String?
    private let projectName:String
    lazy var project: ProjectEntity? = {
       return ProjectEntity.addTaskToProject(self, projectName: self.projectName)
    }()
    let urgency: Double
    let status: String
    let tags: [String]?
    let uuid: String
    let dueDate: String?
    
    init(description: String,
        id: UInt64,
        projectName: String,
        urgency: Double,
        status: String,
        uuid: String,
        dueDate: String? = nil,
        tags: [String]? = nil,
        depends: UInt64? = nil,
        priority: String? = nil
    ) {
        self.description = description
        self.depends = depends
        self.id = id
        self.priority = priority
        self.urgency = urgency
        self.status = status
        self.tags = tags
        self.uuid = uuid
        self.dueDate = dueDate
        self.projectName = projectName
    }
}

//// MARK: Helpers
//extension TaskEntity {
//    // TODO: переписать формат даты
//    private static func dateFromString(string: String?) throws -> NSDate? {
//        guard let string = string else {
//            return nil
//        }
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale.currentLocale()
//        dateFormatter.dateFormat = "yyyy-MM-dd: HH:mm"
//        
//        guard let result = dateFormatter.dateFromString(string) else {
//            throw ConvertError.InvalidParameter(type: "\(self)", from: string)
//        }
//        
//        return result
//    }
//}

// MARK: Decodable
extension TaskEntity: Decodable {
    static func decode(e: Extractor) throws -> TaskEntity {
        return try TaskEntity(
            description: e <| "description",
            id: e <| "id",
            projectName: (e <|? "project") ?? "default",
            urgency: e <| "urgency",
            status: e <| "status",
            uuid: e <| "uuid",
            dueDate: e <|? "due",
            tags: e <||? "tags",
            depends: e <|? "depends",
            priority: e <|? "priority")
    }
}

private enum ConvertError: ErrorType {
    case InvalidParameter(type: String, from: String)
}