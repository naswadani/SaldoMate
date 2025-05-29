//
//  DataEntity+CoreDataProperties.swift
//  SaldoMate
//
//  Created by naswakhansa on 20/05/25.
//
//

import Foundation
import CoreData


extension DataEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataEntity> {
        return NSFetchRequest<DataEntity>(entityName: "DataEntity")
    }

    @NSManaged public var note: String?
    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var name: String

}

extension DataEntity : Identifiable {
    
}
