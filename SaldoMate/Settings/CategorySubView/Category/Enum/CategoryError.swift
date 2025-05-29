//
//  CategoryError.swift
//  SaldoMate
//
//  Created by naswakhansa on 25/05/25.
//

import Foundation

enum CategoryError: LocalizedError {
    case saveFailed(String)
    case errorFetch(String)
    case deleteFailed(String)

    var errorDescription: String? {
        switch self {
        case .saveFailed(let reason):
            return "Failed to save transaction: \(reason)"
        case .errorFetch(let reason):
            return "Failed to fetch transaction: \(reason)"
        case .deleteFailed(let reason):
            return "Failed to delete transaction: \(reason)"
        }
    }
}
