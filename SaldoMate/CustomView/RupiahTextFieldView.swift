//
//  RupiahTextField.swift
//  SaldoMate
//
//  Created by naswakhansa on 21/05/25.
//

import SwiftUI

struct RupiahTextFieldView: View {
    let title: String
    let hint: String
    @Binding var textInput: String
    var action: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.textPrimary)
            
            HStack {
                Text("Rp")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                
                TextField(hint, text: $textInput)
                    .tint(.accent)
                    .fontDesign(.default)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .onChange(of: textInput) {
                        action(textInput)
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.accent.opacity(0.2))
            )
        }
    }
}
