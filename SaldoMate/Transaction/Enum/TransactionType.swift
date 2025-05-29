//
//  TransactionType.swift
//  SaldoMate
//
//  Created by naswakhansa on 26/05/25.
//

import Foundation

enum TransactionType: String, CaseIterable, Identifiable {
    case income = "Income"
    case expense = "Expense"

    var id: String { self.rawValue }
}
