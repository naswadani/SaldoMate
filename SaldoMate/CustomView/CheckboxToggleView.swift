//
//  CheckMarkToggleView.swift
//  SaldoMate
//
//  Created by naswakhansa on 10/05/25.
//

import SwiftUI

struct CheckboxToggleView: View {
    @Binding var isChecked: Bool
    var onToggle: () -> Void
    var label: String
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            Button(action: {
                isChecked.toggle()
                onToggle()
            }) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .accent : .textSecondary)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, 5)
    }
}
