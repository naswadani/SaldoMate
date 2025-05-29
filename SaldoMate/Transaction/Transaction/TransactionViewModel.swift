//
//  TransactionViewModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 23/05/25.
//

import Foundation


class TransactionViewModel: ObservableObject {
    private let repository: TransactionRepositoryProtocol
    private var incomeTransactionData: [TransactionModel]
    private var expenseTransactionData: [TransactionModel]

    @Published var groupedIncomeTransactionData: [String: [TransactionModel]] = [:]
    @Published var groupedExpenseTransactionData: [String: [TransactionModel]] = [:]
    @Published var incomeStateView: TransactionStateView = .idle
    @Published var expenseStateView: TransactionStateView = .idle
    
    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
        self.incomeTransactionData = []
        self.expenseTransactionData = []
        
        fetchData()
        
        NotificationCenter.default.addObserver(
            forName: .transactionDidChange, object: nil, queue: .main
        ) { [weak self] _ in
            self?.fetchData()
        }
    }

    func updateIncomeTransactionState(_ state: TransactionStateView) {
        incomeStateView = state
    }
    
    func updateExpenseTransactionState(_ state: TransactionStateView) {
        expenseStateView = state
    }
    
    func fetchData() {
        getIncomeTransaction()
        getExpensedTransaction()
    }
    
    func getIncomeTransaction() {
        updateIncomeTransactionState(.loading)
        do {
            let all: [TransactionModel] = try repository.getAllTransaction()
            let filtered: [TransactionModel] = all.filter{ $0.type == .income }
            incomeTransactionData = filtered
            groupedIncomeTransactionData = groupTransactionsByMonth(transaction: filtered)
            updateIncomeTransactionState(filtered.isEmpty ? .empty : .success)
        } catch {
            updateIncomeTransactionState(.error(error.localizedDescription))
        }
    }
    
    func getExpensedTransaction() {
        updateExpenseTransactionState(.loading)
        do {
            let all: [TransactionModel] = try repository.getAllTransaction()
            let filtered: [TransactionModel] = all.filter{ $0.type == .expense }
            expenseTransactionData = filtered
            groupedExpenseTransactionData = groupTransactionsByMonth(transaction: filtered)
            
            updateExpenseTransactionState(filtered.isEmpty ? .empty : .success)
        } catch {
            updateExpenseTransactionState(.error(error.localizedDescription))
        }
    }
    
    func deleteTransaction(id: UUID, type: String) {
        do {
            try repository.deleteTransaction(id: id)
            NotificationCenter.default.post(name: .transactionDidChange, object: nil)
        } catch {
            if type.lowercased() == "income" {
                updateIncomeTransactionState(.error(error.localizedDescription))
            } else if type.lowercased() == "expense" {
                updateExpenseTransactionState(.error(error.localizedDescription))
            }
        }
    }
    
    func groupTransactionsByMonth(transaction: [TransactionModel]) -> [String: [TransactionModel]] {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "MMMM yyyy"

        let groupedTransaction: [String: [TransactionModel]] = Dictionary(grouping: transaction) { transaction in
            dateFormatter.string(from: transaction.date)
        }
        
        return groupedTransaction
    }
}
