//
//  TransactionModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 23/05/25.
//

import Foundation

struct TransactionModel: Identifiable {
    let id: UUID
    let name: String
    let amount: Double
    let category: String
    let date: Date
    let type: TransactionType
    let note: String?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.locale = Locale(identifier: "id_ID")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "Rp0"
    }

}
