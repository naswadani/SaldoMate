//
//  AddTransactionView.swift
//  SaldoMate
//
//  Created by naswakhansa on 10/05/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var amountText: String = ""
    @State private var isToday: Bool = true
    
    @StateObject var viewModel: AddTransactionViewModel
    private let categoryRepository: CategoryListRepositoryProtocol
    
    
    init(transactionRepository: TransactionRepositoryProtocol, categoryRepository: CategoryListRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: AddTransactionViewModel(repository: transactionRepository))
        self.categoryRepository = categoryRepository
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                transactionNameField
                transactionAmountField
                transactionDateSection
                transactionTypeSection
                transactionCategorySection
                inputButton
            }
        }
        .navigationTitle("Add Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.accent)
                }
            }
        }
        .padding()
        .onAppear {
            NotificationCenter.default.addObserver(forName: .categoryDidChange, object: nil, queue: .main, using: {notification in
                viewModel.refreshDataCategory()
            })
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .categoryDidChange, object: nil)
        }
    }
    
    var transactionNameField: some View {
        CustomTextFieldView(
            title: "Transaction Name",
            hint: "Enter Name",
            textInput: $viewModel.addTransactionRequest.name
        )
    }
    
    var transactionAmountField: some View {
        RupiahTextFieldView(
            title: "Transaction Amount",
            hint: "0",
            textInput: $viewModel.formattedInput,
            action: viewModel.onAmountChanged
        )
    }
    
    var transactionDateSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Transaction Date")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.textPrimary)
            if isToday {
                HStack {
                    Text(viewModel.addTransactionRequest.formattedDate)
                        .foregroundStyle(.textSecondary)
                        .fontDesign(.default)
                        .padding()
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accent.opacity(0.2))
                )
            } else {
                DatePicker(
                    "",
                    selection: $viewModel.addTransactionRequest.date,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(.accent)
                .padding()
                .background(Color.accent.opacity(0.2))
                .cornerRadius(10)
            }
            CheckboxToggleView(
                isChecked: $isToday,
                onToggle: {
                    if isToday {
                        viewModel.setDateToToday()
                    }
                },
                label: "Today"
            )
        }
    }
    
    var transactionCategorySection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Transaction Category")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.textPrimary)
            
            Group {
                if viewModel.filteredCategories.isEmpty {
                    NavigationLink(destination: CategoryListView(
                        repository: categoryRepository ,
                        selectedType: viewModel.addTransactionRequest.type
                    )) {
                        HStack {
                            Text("Add Category")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.title2)
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        Picker("Category", selection: $viewModel.addTransactionRequest.category) {
                            ForEach(viewModel.filteredCategories) { category in
                                Text(category.category.capitalized)
                                    .tag(category.category as String)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.accent)
                    }
                }
            }
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accent.opacity(0.2))
            )
        }
    }
    
    
    var transactionTypeSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Transaction Type")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.textPrimary)
            
            Picker("Transaction Type", selection: Binding(
                get: { viewModel.addTransactionRequest.type },
                set: { viewModel.updateTransactionType($0) }
            )) {
                ForEach(TransactionType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accent.opacity(0.2))
            )
        }
    }
    
    var inputButton: some View {
        CustomButtonInputView(
            action: viewModel.createTransaction,
            isFormValid: viewModel.isFormValid
        )
    }
}

#Preview {
    AddTransactionView(
        transactionRepository: TransactionRepository(context: PersistenceController.shared.container.viewContext), categoryRepository: CategoryListRepository(context: PersistenceController.shared.container.viewContext)
    )
}
