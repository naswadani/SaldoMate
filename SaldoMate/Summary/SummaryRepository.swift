//
//  SummaryRepository.swift
//  SaldoMate
//
//  Created by naswakhansa on 30/05/25.
//

import Foundation
import CoreData
import SwiftUICore

protocol SummaryRepositoryProtocol {
    func fetchAllCategories() throws -> [CategoryModel]
    func getAllTransaction() throws -> [TransactionModel]
}

class SummaryRepository: SummaryRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
    
    func getAllTransaction() throws -> [TransactionModel] {
        let fetchRequest: NSFetchRequest<DataEntity> = DataEntity.fetchRequest()

        do {
            let transactions = try context.fetch(fetchRequest)

            return transactions.compactMap { data in
                guard let type = TransactionType(rawValue: data.type) else {
                    return nil
                }

                return TransactionModel(
                    id: data.id,
                    name: data.name,
                    amount: data.amount,
                    category: data.category,
                    date: data.date,
                    type: type,
                )
            }
        } catch {
            throw TransactionError.errorFetch(error.localizedDescription)
        }
    }
}
