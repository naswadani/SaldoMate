//
//  TransactionListItemView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct TransactionListItemView: View {
    let data: TransactionModel
    let colorTransaction: Color
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                itemIdentifierView
                Spacer()
                amoutView
            }
            .frame(minHeight: 70, alignment: .center)
            .padding(.horizontal, 20)
        }
    }
    
    private var amoutView: some View {
        VStack(alignment: .trailing) {
            Text(data.formattedAmount)
                .fontDesign(.default)
                .font(.headline)
                .bold()
                .foregroundStyle(colorTransaction)
            
            Text(data.category)
                .fontDesign(.default)
                .font(.subheadline)
                .foregroundStyle(.textPrimary)
        }
    }
    
    private var itemIdentifierView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(data.name)
                .fontDesign(.default)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .bold()
                .foregroundStyle(.textPrimary)
            
            Text(data.formattedDate)
                .fontDesign(.default)
                .font(.subheadline)
                .foregroundStyle(.textPrimary)
        }
        .padding(.horizontal, 5)
    }
}


