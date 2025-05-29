//
//  CategorySheetInputContentView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct CategorySheetInputContentView: View {
    @Binding var text: String
    @Binding var showSheet: Bool
    @State private var isActive = true
    var isFormValid: Bool
    var action: () -> Void
    var action2: () -> Void
    
    var body: some View {
        HStack {
            AutoFocusTextField(text: $text, isFirstResponder: $isActive)
                .frame(height: 40)
                .tint(.accent)
                .onChange(of: text) {
                    action2()
                }
            
            Spacer()
            
            Button("Submit") {
                showSheet = false
                action()
            }
            .foregroundStyle(isFormValid ? .accent : .textSecondary)
            .disabled(!isFormValid)
        }
        .padding(.horizontal)
    }
}


#Preview {
    CategorySheetInputContentView(text: .constant(""), showSheet: .constant(true), isFormValid: true, action: {}, action2: {})
}
