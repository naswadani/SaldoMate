//
//  SettingsRowView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//


import SwiftUI

struct SettingsRowView: View {
    var name : String
    var content: String
    var body: some View {
        VStack {
            Divider()
                .padding(.vertical, 4)
            HStack {
                Text(name)
                    .fontDesign(.default)
                    .foregroundStyle(.textSecondary)
                Spacer()
                Text(content)
                    .fontDesign(.default)
                    .foregroundStyle(.textPrimary)
                
            }
        }
    }
}

#Preview {
    SettingsRowView(name: "Developer", content: "John / Jane")
}
