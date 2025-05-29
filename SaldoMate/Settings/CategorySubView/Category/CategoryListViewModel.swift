//
//  CategoryListViewModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 25/05/25.
//

import Foundation

class CategoryListViewModel: ObservableObject {
    private let repository: CategoryListRepositoryProtocol
    private let selectedType: TransactionType
    
    @Published var categories: [CategoryModel]
    @Published var categoriesRequest: CategoryRequestModel
    @Published var stateView: CategoryStateView
    @Published var isFormValid: Bool = false
    
    init(repository: CategoryListRepositoryProtocol, selectedType: TransactionType) {
        self.repository = repository
        self.stateView = .idle
        self.selectedType = selectedType
        self.categories = []
        self.categoriesRequest = CategoryRequestModel(type: selectedType, category: "")
        
        fetchCategories()
        
        NotificationCenter.default.addObserver(
            forName: .categoryDidChange, object: nil, queue: .main
        ) { [weak self] _ in
            self?.fetchCategories()
        }
    }
    
    private func updateCategoryState(_ state: CategoryStateView) {
        stateView = state
    }
    
    @discardableResult
    func validateForm() -> Bool {
        let isValid: Bool = !categoriesRequest.category.trimmingCharacters(in: .whitespaces).isEmpty
        
        self.isFormValid = isValid
        return isValid
    }
    
    
    private func fetchCategories() {
        if selectedType == .income {
            self.fetchIncomeCategories()
        } else {
            self.fetchExpenseCategories()
        }
    }
    
    func fetchIncomeCategories() {
        do {
            let all: [CategoryModel] = try repository.fetchAllCategories()
            let filteredData: [CategoryModel] = all.filter{ $0.type == .income}
            categories = filteredData
            
            updateCategoryState(filteredData.isEmpty ? .empty : .success)
        } catch {
            updateCategoryState(.error(error.localizedDescription))
        }
    }
    
    func fetchExpenseCategories() {
        do {
            let all: [CategoryModel] = try repository.fetchAllCategories()
            let filteredData: [CategoryModel] = all.filter{ $0.type == .expense}
            categories = filteredData
            
            updateCategoryState(filteredData.isEmpty ? .empty : .success)
        } catch {
            updateCategoryState(.error(error.localizedDescription))
        }
    }
    
    func createCategory() {
        do {
            try repository.addCategory(categoriesRequest)
            self.categoriesRequest = CategoryRequestModel(type: selectedType, category: "")
            updateCategoryState(.success)
            NotificationCenter.default.post(name: .categoryDidChange, object: nil)
        } catch let error as TransactionError {
            updateCategoryState(.error(error.localizedDescription))
        } catch {
            updateCategoryState(.error("Unknown error occurred"))
        }
    }

    func deleteCategory(id: UUID, type: String) {
        do {
            try repository.deleteCategory(id: id)
            NotificationCenter.default.post(name: .categoryDidChange, object: nil)
        } catch {
            updateCategoryState(.error(error.localizedDescription))
        }
    }
}
