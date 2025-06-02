//
//  SummaryViewModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 30/05/25.
//

import Foundation
import SwiftUI

final class SummaryViewModel: ObservableObject {
    private let repository: SummaryRepositoryProtocol
    private let calendar = Calendar.current
    
    @Published var selectedCategories: [TransactionType: String?] = [
        .income: nil,
        .expense: nil
    ]
    
    @Published var monthlyIncomeTransactions: [TransactionModel] = []
    @Published var monthlyExpenseTransactions: [TransactionModel] = []
    
    @Published var selectedSection: TransactionType = .income
    
    @Published var incomeStateView: SummaryStateView = .idle
    @Published var expenseStateView: SummaryStateView = .idle
    
    @Published var chartData: [SummaryModel] = []
    @Published var incomeCategories: [CategoryModel] = []
    @Published var expenseCategories: [CategoryModel] = []
    
    var selectedCategory: String? {
        selectedCategories[selectedSection] ?? nil
    }

        
    
    var totalAmount: Double {
        chartData.reduce(0) { $0 + $1.totalAmount }
    }
    
    init(repository: SummaryRepositoryProtocol) {
        self.repository = repository
        
        fetchInitialData()
        
        NotificationCenter.default.addObserver(
            forName: .transactionDidChange, object: nil, queue: .main
        ) { [weak self] _ in
            self?.fetchInitialData()
        }
        
        NotificationCenter.default.addObserver(
            forName: .categoryDidChange, object: nil, queue: .main
        ) { [weak self] _ in
            self?.fetchInitialData()
        }
    }
    
    var monthlyTransactions: [TransactionModel] {
        selectedSection == .income ? monthlyIncomeTransactions : monthlyExpenseTransactions
    }
    
    func fetchInitialData() {
        selectedSection = .income
        loadData()
    }
    
    func loadData() {
        fetchMonthlyTransactions()
        fetchIncomeCategories()
        fetchExpenseCategories()
    }
    
    private func updateIncomeStateView(_ state: SummaryStateView) {
        DispatchQueue.main.async {
            self.incomeStateView = state
        }
    }
    
    private func updateExpenseStateView(_ state: SummaryStateView) {
        DispatchQueue.main.async {
            self.expenseStateView = state
        }
    }
    
    func fetchMonthlyTransactions() {
        do {
            let allTransactions = try repository.getAllTransaction()
            let currentMonth = calendar.component(.month, from: Date())
            let currentYear = calendar.component(.year, from: Date())
            
            let filteredTransactions = allTransactions.filter {
                let month = calendar.component(.month, from: $0.date)
                let year = calendar.component(.year, from: $0.date)
                return month == currentMonth && year == currentYear
            }
            
            monthlyIncomeTransactions = filteredTransactions.filter { $0.type == .income }
            monthlyExpenseTransactions = filteredTransactions.filter { $0.type == .expense }
            
            updateIncomeStateView(monthlyIncomeTransactions.isEmpty ? .empty : .success)
            updateExpenseStateView(monthlyExpenseTransactions.isEmpty ? .empty : .success)
        } catch {
            let errorState = SummaryStateView.error(error.localizedDescription)
            updateIncomeStateView(errorState)
            updateExpenseStateView(errorState)
        }
    }
    
    func calculateMonthlySummaryPerCategory(
        from transactions: [TransactionModel],
        categories: [CategoryModel]
    ) -> [SummaryModel] {
        categories.map { category in
            let total = transactions
                .filter { $0.category == category.category }
                .reduce(0) { $0 + $1.amount }
            
            return SummaryModel(id: UUID(), category: category, totalAmount: total)
        }
    }
    
    func fetchIncomeCategories() {
        do {
            let categories = try repository.fetchAllCategories()
            incomeCategories = categories.filter { $0.type == .income }
            
            updateIncomeStateView(incomeCategories.isEmpty ? .empty : .success)
            updateSummary()
        } catch {
            updateIncomeStateView(.error(error.localizedDescription))
        }
    }
    
    func fetchExpenseCategories() {
        do {
            let categories = try repository.fetchAllCategories()
            expenseCategories = categories.filter { $0.type == .expense }
            
            updateExpenseStateView(expenseCategories.isEmpty ? .empty : .success)
            updateSummary()
        } catch {
            updateExpenseStateView(.error(error.localizedDescription))
        }
    }
    
    func updateSummary() {
        switch selectedSection {
        case .income:
            chartData = calculateMonthlySummaryPerCategory(
                from: monthlyIncomeTransactions,
                categories: incomeCategories
            )
        case .expense:
            chartData = calculateMonthlySummaryPerCategory(
                from: monthlyExpenseTransactions,
                categories: expenseCategories
            )
        }
    }
    
    func getTransactions(for category: CategoryModel) -> [TransactionModel] {
        switch category.type {
        case .income:
            return monthlyIncomeTransactions.filter { $0.category == category.category }
        case .expense:
            return monthlyExpenseTransactions.filter { $0.category == category.category }
        }
    }
    
    func getChartData(
        from transactions: [TransactionModel],
        categories: [CategoryModel],
        month: Int,
        year: Int,
        type: TransactionType
    ) -> [(categoryName: String, totalAmount: Double)] {
        let filteredTransactions = transactions.filter {
            $0.type == type &&
            calendar.component(.month, from: $0.date) == month &&
            calendar.component(.year, from: $0.date) == year
        }
        
        return categories.compactMap { category in
            let total = filteredTransactions
                .filter { $0.category == category.category }
                .reduce(0) { $0 + $1.amount }
            
            return total > 0 ? (category.category, total) : nil
        }
    }
    
    func selectedItem() -> SummaryModel? {
        guard let selected = selectedCategory else { return nil }
        return chartData.first { $0.category.category == selected }
    }
    
    func handleTap(at location: CGPoint, chartSize: CGSize) {
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        let dx = location.x - center.x
        let dy = location.y - center.y
        
        let distance = sqrt(dx * dx + dy * dy)
        let outerRadius: CGFloat = 120
        let innerRadius: CGFloat = outerRadius * 0.6
        
        guard distance >= innerRadius && distance <= outerRadius else {
            withAnimation {
                selectedCategories[selectedSection] = nil
            }
            return
        }
        
        var angle = atan2(dx, -dy) * 180 / .pi
        if angle < 0 { angle += 360 }
        
        var cumulativeAngle: Double = 0
        for item in chartData {
            let angleRange = (item.totalAmount / totalAmount) * 360
            let endAngle = cumulativeAngle + angleRange
            if angle >= cumulativeAngle && angle < endAngle {
                withAnimation {
                    if selectedCategories[selectedSection] == item.category.category {
                        selectedCategories[selectedSection] = nil
                    } else {
                        selectedCategories[selectedSection] = item.category.category
                    }
                }
                return
            }
            cumulativeAngle += angleRange
        }
    }
}
