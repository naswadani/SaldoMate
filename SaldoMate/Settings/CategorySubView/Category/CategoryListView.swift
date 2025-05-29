//
//  IncomeCategoryListView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showSheet = false
    var selectedType: TransactionType
    
    init(repository: CategoryListRepositoryProtocol, selectedType: TransactionType) {
        self.selectedType = selectedType
        _viewModel = StateObject(
            wrappedValue: CategoryListViewModel(repository: repository, selectedType: selectedType)
        )
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.categories) { item in
                    CategoryListItemView(categoryName: item.category)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteCategory(id: item.id, type: item.type.rawValue)
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .tint(.red)
                            }
                        }
                }
            }
            .navigationTitle("\(selectedType.rawValue) Category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        dismiss()
                    }) {
                        CustomBackButtonView()
                    }
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        showSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.accent)
                    }
                })
            })
            .sheet(isPresented: $showSheet) {
                CategorySheetInputContentView(
                    text: $viewModel.categoriesRequest.category,
                    showSheet: $showSheet,
                    isFormValid: viewModel.isFormValid)
                {
                    viewModel.createCategory()
                } action2: {
                    viewModel.validateForm()
                }
                .presentationDetents([.height(75)])
            }
        }
    }
}

#Preview {
    CategoryListView(repository: CategoryListRepository(context: PersistenceController.shared.container.viewContext), selectedType: .income)
}
