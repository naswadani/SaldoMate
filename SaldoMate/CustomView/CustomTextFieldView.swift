//
//  CustomTextFieldView.swift
//  SaldoMate
//
//  Created by naswakhansa on 10/05/25.
//

import SwiftUI

struct CustomTextFieldView: View {
    let title: String
    let hint: String
    @Binding var textInput: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.textPrimary)
            TextField(hint, text: $textInput)
                .tint(.accent)
                .fontDesign(.default)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.accent.opacity(0.2))
                )
            
        }
    }
}

#Preview {
    CustomTextFieldView(title: "Transaction Name", hint: "Enter Transaction Name", textInput: .constant("Transfer"))
}
