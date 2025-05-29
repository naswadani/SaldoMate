//
//  CustomButtonInputView.swift
//  SaldoMate
//
//  Created by naswakhansa on 10/05/25.
//

import SwiftUI

struct CustomButtonInputView: View {
    var action: () -> Void
    @Environment(\.dismiss) var dismiss
    var isFormValid: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: {
                action()
                dismiss()
            }) {
                Text("Input")
                    .font(.headline)
                    .bold()
                    .padding()
                    .foregroundStyle(.textPrimary)
            }
            .disabled(!isFormValid)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isFormValid ? Color.accent : Color.gray.opacity(0.3))
        )
    }
}
