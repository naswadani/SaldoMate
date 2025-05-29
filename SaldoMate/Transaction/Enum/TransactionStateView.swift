//
//  TransactionStateView.swift
//  SaldoMate
//
//  Created by naswakhansa on 12/05/25.
//

import Foundation

enum TransactionStateView {
    case idle
    case success
    case loading
    case empty
    case error(String)
}
