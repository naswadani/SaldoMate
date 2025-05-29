//
//  CategoryEntity+CoreDataProperties.swift
//  SaldoMate
//
//  Created by naswakhansa on 25/05/25.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var category: String

}

extension CategoryEntity : Identifiable {

}
