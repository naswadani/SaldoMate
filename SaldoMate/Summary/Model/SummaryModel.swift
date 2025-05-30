//
//  SummaryModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 30/05/25.
//

import Foundation

struct SummaryModel: Identifiable {
    var id: UUID
    var category: CategoryModel
    var totalAmount: Double
}
