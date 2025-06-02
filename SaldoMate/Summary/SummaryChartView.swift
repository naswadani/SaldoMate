//
//  SummaryChartView.swift
//  SaldoMate
//
//  Created by naswakhansa on 07/05/25.
//

import SwiftUI
import Charts

struct SummaryChartView: View {
    var typeTransaction: TransactionType
    var chartData: [SummaryModel]
    var selectedCategory: String?
    var handleTap: (_ location: CGPoint, _ chartSize: CGSize) -> Void
    var selectedItem: () -> SummaryModel?
    var totalAmount: Double
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Chart(chartData, id: \.id) { item in
                    SectorMark(
                        angle: .value("Total", item.totalAmount),
                        innerRadius: .ratio(0.7),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Category", item.category.category))
                    .opacity({
                        let selected = selectedCategory
                        if selected == nil {
                            return 1
                        } else if selected == item.category.category {
                            return 1
                        } else {
                            return 0.3
                        }
                    }())
                    
                }
                .frame(height: 300)
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: 300, height: 300)
                    .contentShape(Circle())
                    .onTapGesture { location in
                        handleTap(location, CGSize(width: 300, height: 300))
                    }
                    .allowsHitTesting(true)
                
                VStack(alignment: .center,spacing: 4) {
                    if let selected = selectedCategory,
                       let item = selectedItem() {
                        Text(selected)
                            .font(.subheadline)
                        Text("Rp\(item.totalAmount, specifier: "%.0f")")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    } else {
                        Text("Total \(typeTransaction.rawValue) ")
                            .font(.subheadline)
                        Text("Rp\(totalAmount, specifier: "%.0f")")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                )
                .allowsHitTesting(false)
            }
        }
        .padding()
    }
}
