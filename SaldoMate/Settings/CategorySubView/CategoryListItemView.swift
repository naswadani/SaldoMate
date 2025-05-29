//
//  CategoryListItemView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct CategoryListItemView: View {
    let categoryName: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(categoryName)
                    .font(.headline)
                    .fontDesign(.default)
                    .foregroundStyle(.textPrimary)
                    .padding(.horizontal)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    CategoryListItemView(categoryName: "Bank Tranfer")
}
