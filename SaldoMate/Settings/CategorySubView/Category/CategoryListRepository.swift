//
//  CategoryListRepository.swift
//  SaldoMate
//
//  Created by naswakhansa on 25/05/25.
//

import Foundation
import CoreData
import SwiftUICore

protocol CategoryListRepositoryProtocol {
    func addCategory(_ categoryData: CategoryRequestModel) throws
    func deleteCategory(id: UUID) throws
    func fetchAllCategories() throws -> [CategoryModel]
}

class CategoryListRepository: CategoryListRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addCategory(_ categoryData: CategoryRequestModel) throws {
        let category: CategoryEntity = CategoryEntity(context: context)
        category.id = UUID()
        category.type = categoryData.type.rawValue
        category.category = categoryData.category
        
        do {
            try context.save()
        } catch {
            throw CategoryError.saveFailed(error.localizedDescription)
        }
    }
    
    func deleteCategory(id: UUID) throws {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {
                context.delete(category)
            }
            try context.save()
        } catch {
            throw CategoryError.deleteFailed(error.localizedDescription)
        }
    }
    
    func fetchAllCategories() throws -> [CategoryModel] {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()

        do {
            let categories = try context.fetch(fetchRequest)

            return categories.compactMap { category in
                guard let type = TransactionType(rawValue: category.type) else {
                    return nil
                }

                return CategoryModel(
                    id: category.id,
                    type: type,
                    category: category.category
                )
            }
        } catch {
            throw CategoryError.errorFetch(error.localizedDescription)
        }
    }

}

