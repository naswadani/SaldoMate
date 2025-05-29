//
//  TransactionRepository.swift
//  SaldoMate
//
//  Created by naswakhansa on 12/05/25.
//

import Foundation
import CoreData
import SwiftUICore

protocol TransactionRepositoryProtocol {
    func addTransaction(_ transactionRequest: AddTransactionRequestModel) throws
    func getAllTransaction() throws -> [TransactionModel]
    func deleteTransaction(id: UUID) throws
    func fetchAllCategories() throws -> [CategoryModel]
}

class TransactionRepository: TransactionRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addTransaction(_ transactionRequest: AddTransactionRequestModel) throws {
        let transaction: DataEntity = DataEntity(context: context)
        transaction.amount = transactionRequest.amount
        transaction.category = transactionRequest.category
        transaction.date = transactionRequest.date
        transaction.type = transactionRequest.type.rawValue
        transaction.note = transactionRequest.note
        transaction.name = transactionRequest.name
        transaction.id = UUID()
        
        do {
            try context.save()
        } catch {
            throw TransactionError.saveFailed(error.localizedDescription)
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
                    note: data.note
                )
            }
        } catch {
            throw TransactionError.errorFetch(error.localizedDescription)
        }
    }

    func deleteTransaction(id: UUID) throws {
        let fetchRequest: NSFetchRequest<DataEntity> = DataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let transactions = try context.fetch(fetchRequest)
            for transaction in transactions {
                context.delete(transaction)
            }
            try context.save()
        } catch {
            throw TransactionError.deleteFailed(error.localizedDescription)
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
