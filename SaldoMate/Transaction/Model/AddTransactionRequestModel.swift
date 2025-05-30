//
//  AddTransactionRequestModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 12/05/25.
//

import Foundation

struct AddTransactionRequestModel {
    var name: String
    var amount: Double
    var category: String
    var date: Date
    var type: TransactionType
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: date)
    }

}
