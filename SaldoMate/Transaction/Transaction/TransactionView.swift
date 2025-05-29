//
//  TransactionView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import Foundation
import SwiftUI

struct TransactionView: View {
    @StateObject var viewModel: TransactionViewModel
    @State private var selectedSection: TransactionType = .income
    @State private var addTransactionViewIsPresented: Bool = false
    @Environment(\.managedObjectContext) private var context
    
    init(repository: TransactionRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: TransactionViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Picker("Select Section", selection: $selectedSection) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.background)
                    
                    ZStack {
                        incomeList
                            .opacity(selectedSection == .income ? 1 : 0)
                            .accessibilityHidden(selectedSection != .income)
                        
                        expenseList
                            .opacity(selectedSection == .expense ? 1 : 0)
                            .accessibilityHidden(selectedSection != .expense)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            addTransactionViewIsPresented = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.accent)
                                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                                )
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $addTransactionViewIsPresented) {
                NavigationStack {
                    AddTransactionView(
                        transactionRepository: TransactionRepository(context: context),
                        categoryRepository: CategoryListRepository(context: context)
                    )
                }
            }
        }
    }
    
    private var incomeList: some View {
        List {
            ForEach(viewModel.groupedIncomeTransactionData.keys.sorted(by: >), id: \.self) { month in
                Section(header: Text(month)) {
                    ForEach(viewModel.groupedIncomeTransactionData[month] ?? []) { item in
                        TransactionListItemView(
                            titleTransaction: item.name,
                            dateTransaction: item.formattedDate,
                            amountTransaction: item.formattedAmount,
                            colorTransaction: Color.green,
                            categoryTransaction: item.category,
                            needPadding: true
                        )
                        .listRowInsets(EdgeInsets())
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteTransaction(id: item.id, type: "trash")
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }.tint(.red)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var expenseList: some View {
        List {
            ForEach(viewModel.groupedExpenseTransactionData.keys.sorted(by: >), id: \.self) { month in
                Section(header: Text(month)) {
                    ForEach(viewModel.groupedExpenseTransactionData[month] ?? []) { item in
                        TransactionListItemView(
                            titleTransaction: item.name,
                            dateTransaction: item.formattedDate,
                            amountTransaction: item.formattedAmount,
                            colorTransaction: Color.green,
                            categoryTransaction: item.category,
                            needPadding: true
                        )
                        .listRowInsets(EdgeInsets())
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteTransaction(id: item.id, type: "trash")
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }.tint(.red)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}


#Preview {
    TransactionView(repository: TransactionRepository(context: PersistenceController.shared.container.viewContext))
}
