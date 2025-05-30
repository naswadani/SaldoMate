//
//  TransactionViewModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 12/05/25.
//

import Foundation
import Combine
import SwiftUI

class AddTransactionViewModel: ObservableObject {
    private let repository: TransactionRepositoryProtocol
    var cancellables = Set<AnyCancellable>()
    
    let transactionTypes: [TransactionType] = TransactionType.allCases
    
    @Published var incomeCategories: [CategoryModel] = []
    @Published var expenseCategories: [CategoryModel] = []
    @Published var incomeStateView: AddTransactionStateView = .idle
    @Published var expenseStateView: AddTransactionStateView = .idle
    @Published var isFormValid: Bool = false
    @Published var formattedInput: String = ""
    @Published var addTransactionRequest: AddTransactionRequestModel {
        didSet {
            validateForm()
        }
    }
    
    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
        self.addTransactionRequest = .init(
            name: "",
            amount: 0,
            category: "",
            date: Date(),
            type: .income
        )
        validateForm()
        fetchDataCategory()
        updateTransactionType(.income)
    }
    
    func updateTransactionType(_ newType: TransactionType) {
        addTransactionRequest.type = newType
        addTransactionRequest.category = filteredCategories.first?.category ?? ""
        validateForm()
    }
    
    var filteredCategories: [CategoryModel] {
        switch addTransactionRequest.type {
        case .income:
            return incomeCategories
        case .expense:
            return expenseCategories
        }
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    func refreshDataCategory() {
        fetchDataCategory()
        addTransactionRequest.category = filteredCategories.first?.category ?? ""
        validateForm()
    }

    private func fetchDataCategory() {
        fetchIncomeCategories()
        fetchExpenseCategories()
    }

    
    func validateForm() {
        let categoryTrimmed = addTransactionRequest.category.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let isCategoryValid = !categoryTrimmed.isEmpty
        
        let isNameValid = !addTransactionRequest.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isAmountValid = addTransactionRequest.amount > 0
        
        isFormValid = isCategoryValid && isNameValid && isAmountValid
    }
    
    private func updateTransactionState(_ state: AddTransactionStateView) {
        incomeStateView = state
    }
    
    func createTransaction() {
        do {
            try repository.addTransaction(addTransactionRequest)
            updateTransactionState(.success)
            NotificationCenter.default.post(name: .transactionDidChange, object: nil)
        } catch let error as TransactionError {
            updateTransactionState(.error(error.localizedDescription))
        } catch {
            updateTransactionState(.error("Unknown error occurred"))
        }
    }
    
    func setDateToToday() {
        addTransactionRequest.date = Date()
    }
    
    func onAmountChanged(_ newInput: String) {
        let digitsOnly = newInput.filter { "0123456789".contains($0) }
        
        if let amount = Double(digitsOnly) {
            addTransactionRequest.amount = amount
            
            if let formatted = numberFormatter.string(from: NSNumber(value: amount)) {
                if formattedInput != formatted {
                    formattedInput = formatted
                }
            }
        } else {
            addTransactionRequest.amount = 0
            formattedInput = ""
        }
        validateForm()
    }
    
    private func fetchIncomeCategories() {
        do {
            let all: [CategoryModel] = try repository.fetchAllCategories()
            let filtered: [CategoryModel] = all.filter({ $0.type == .income })
            incomeCategories = filtered
            
            updateTransactionState(filtered.isEmpty ? .empty : .success)
        } catch {
            updateTransactionState(.error(error.localizedDescription))
        }
    }
    
    private func fetchExpenseCategories() {
        do {
            let all: [CategoryModel] = try repository.fetchAllCategories()
            let filtered: [CategoryModel] = all.filter({ $0.type == .expense })
            expenseCategories = filtered
            
            updateTransactionState(filtered.isEmpty ? .empty : .success)
        } catch {
            updateTransactionState(.error(error.localizedDescription))
        }
    }
}
