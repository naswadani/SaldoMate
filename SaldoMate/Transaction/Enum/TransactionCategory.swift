//
//  TransactionCategory.swift
//  SaldoMate
//
//  Created by naswakhansa on 21/05/25.
//

import Foundation

enum TransactionCategory: String, CaseIterable, Identifiable {
    case food = "Food"
    case bills = "Bills"
    case salary = "Salary"
    case shopping = "Shopping"
    case health = "Health"
    case transfer = "Bank Transfer"
    case groceries = "Groceries"
    case transport = "Transport"
    case entertainment = "Entertainment"
    
    var id: String { self.rawValue }
}
