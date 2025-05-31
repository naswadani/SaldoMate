//
//  SummaryView.swift
//  SaldoMate
//
//  Created by naswakhansa on 07/05/25.
//

import SwiftUI


struct SummaryView: View {
    @StateObject var viewModel: SummaryViewModel
    @Environment(\.managedObjectContext) private var context
    
    init(repository: SummaryRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: SummaryViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    SummaryChartView(
                        chartData: viewModel.chartData,
                        selectedCategory: viewModel.selectedCategory,
                        handleTap: { location,size in
                            viewModel.handleTap(at: location, chartSize: size)
                        },
                        selectedItem: {
                            viewModel.selectedItem()
                        },
                        totalIncome: viewModel.totalAmount
                    )
                    Picker("Select Section", selection: $viewModel.selectedSection) {
                        Text("Income").tag(TransactionType.income)
                        Text("Expense").tag(TransactionType.expense)
                    }
                    .padding(.horizontal, 10)
                    .padding(30)
                    .pickerStyle(SegmentedPickerStyle())
                    .tint(.secondary)
                    .onChange(of: viewModel.selectedSection) {
                        viewModel.updateSummary()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .padding()
                            .foregroundStyle(Color.accent.opacity(0.3))
                    )
                    
                    //                    let dataToShow = selectedSection == 0 ? incomeData : expenseData
                    //
                    //                    ForEach(dataToShow, id: \.0) { item in
                    //                        TransactionListItemView(
                    //                            titleTransaction: item.0,
                    //                            dateTransaction: item.1,
                    //                            amountTransaction: item.2,
                    //                            colorTransaction: item.3,
                    //                            categoryTransaction: item.4,
                    //                            needPadding: false,
                    //                            hadNote: item.4
                    //                        )
                    //                    }
                    //                    .padding(.horizontal)
                }
            }
            .onAppear {
                viewModel.fetchInitialData()
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
