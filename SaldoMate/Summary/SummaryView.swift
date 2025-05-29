//
//  SummaryView.swift
//  SaldoMate
//
//  Created by naswakhansa on 07/05/25.
//

import SwiftUI

struct PostCount {
    var category: String
    var count: Int
}

struct SummaryView: View {
    @State private var selectedSection = 0
    
    let incomeData = [
        ("Transfer Dari Teman", "07/05/2025", "Rp 1,500,000", Color.green, "Bank Transfer"),
        ("Gaji Bulan Mei", "10/05/2025", "Rp 5,000,000", Color.green, "Salary")
    ]
    let expenseData = [
        ("Pembelian Makanan", "06/05/2025", "Rp 200,000", Color.red, "Food Spending"),
        ("Bayar Listrik", "08/05/2025", "Rp 50,000", Color.red, "Bill"),
        ("Beli Pulsa", "10/05/2025", "Rp 100,000", Color.red, "Bill"),
        ("Sewa Rumah", "12/05/2025", "Rp 1,000,000", Color.red, "House"),
        ("Beli Bahan Makanan", "14/05/2025", "Rp 300,000", Color.red, "Groceries"),
        ("Beli Pakaian", "16/05/2025", "Rp 500,000", Color.red, "Shopping"),
        ("Jalan-Jalan", "18/05/2025", "Rp 1,000,000", Color.red, "Personal Spending"),
        ("Bayar Internet", "20/05/2025", "Rp 350,000", Color.red, "Billing"),
        ("Biaya Kesehatan", "22/05/2025", "Rp 150,000", Color.red, "Billing"),
        ("Transportasi", "24/05/2025", "Rp 200,000", Color.red, "Daily Life Spending")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    SummaryChartView()
                    
                    Picker("Select Section", selection: $selectedSection) {
                        Text("Income").tag(0)
                        Text("Expense").tag(1)
                    }
                    .padding(.horizontal, 10)
                    .padding(30)
                    .pickerStyle(SegmentedPickerStyle())
                    .tint(.secondary)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .padding()
                            .foregroundStyle(Color.accent.opacity(0.3))
                    )
                    
                    let dataToShow = selectedSection == 0 ? incomeData : expenseData
                    
                    ForEach(dataToShow, id: \.0) { item in
                        TransactionListItemView(
                            titleTransaction: item.0,
                            dateTransaction: item.1,
                            amountTransaction: item.2,
                            colorTransaction: item.3,
                            categoryTransaction: item.4,
                            needPadding: false
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Action export / share
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
}


#Preview {
    SummaryView()
}
