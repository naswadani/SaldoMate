//
//  TransactionListItemView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct TransactionListItemView: View {
    let titleTransaction: String
    let dateTransaction: String
    let amountTransaction: String
    let colorTransaction: Color
    let categoryTransaction: String
    let needPadding: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(titleTransaction)
                        .fontDesign(.default)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .foregroundStyle(.textPrimary)
                    
                    Text(dateTransaction)
                        .fontDesign(.default)
                        .font(.subheadline)
                        .foregroundStyle(.textPrimary)
                }
                .padding(.trailing, 10)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(amountTransaction)
                        .fontDesign(.default)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(colorTransaction)
                    
                    Text(categoryTransaction)
                        .fontDesign(.default)
                        .font(.subheadline)
                        .foregroundStyle(.textPrimary)
                }
            }
            .frame(minHeight: 70, alignment: .center)
            .padding(.horizontal, 20)
        }
    }
}


#Preview {
    TransactionListItemView(titleTransaction: "Pembayaran Makan Geprek", dateTransaction: "06/05/2025", amountTransaction: "Rp 500,000", colorTransaction: .incomeLabel, categoryTransaction: "Jajan", needPadding: true)
}
