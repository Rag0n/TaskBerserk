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
    let id: String
    let priority: String?
    private let projectName:String
//    var project: ProjectEntity
    lazy var project: ProjectEntity = {
       return ProjectEntity.addTaskToProject(self, projectName: self.projectName)
    }()
    let urgency: Double
    let status: String
    let tags: [String]?
    let dueDate: String?
    
    init(description: String,
        id: String,
        projectName: String,
        urgency: Double,
        status: String,
        dueDate: String? = nil,
        tags: [String]? = nil,
        priority: String? = nil
    ) {
        self.description = description
        self.id = id
        self.priority = priority
        self.urgency = urgency
        self.status = status
        self.tags = tags
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
            dueDate: e <|? "due",
            tags: e <||? "tags",
            priority: e <|? "priority")
    }
}

private enum ConvertError: ErrorType {
    case InvalidParameter(type: String, from: String)
}