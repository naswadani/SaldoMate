//
//  CategoryModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 25/05/25.
//

import Foundation

struct CategoryModel: Identifiable, Equatable {
    var id: UUID
    var type: TransactionType
    var category: String
}
