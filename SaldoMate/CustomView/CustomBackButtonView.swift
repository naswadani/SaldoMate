//
//  CustomBackButtonView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct CustomBackButtonView: View {
    var body: some View {
        Image(systemName: "chevron.left.circle.fill")
            .font(.title3)
            .foregroundStyle(.accent)
    }
}

#Preview {
    CustomBackButtonView()
}
