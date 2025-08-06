//
//  CDTodo+CoreDataProperties.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//
//

import Foundation
import CoreData


extension CDTodo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTodo> {
        return NSFetchRequest<CDTodo>(entityName: "CDTodo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var completed: Bool
    @NSManaged public var createdAt: Date?

}

extension CDTodo : Identifiable {

}
