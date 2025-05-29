//
//  SettingsLabelView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//


import SwiftUI

struct SettingsLabelView: View {
    var labelText : String
    var labelImage : String
    var body: some View {
        HStack {
            Text(labelText.uppercased())
                .fontDesign(.default)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Spacer()
            Image(systemName: labelImage)
        }
    }
}

#Preview {
    SettingsLabelView(labelText: "Fructus", labelImage: "info.circle")
}
