//
//  SummaryChartView.swift
//  SaldoMate
//
//  Created by naswakhansa on 07/05/25.
//

import SwiftUI
import Charts

struct SummaryChartView: View {
    var chartData: [SummaryModel]
    var selectedCategory: String?
    var handleTap: (_ location: CGPoint, _ chartSize: CGSize) -> Void
    var selectedItem: () -> SummaryModel?
    var totalIncome: Double
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Chart(chartData, id: \.id) { item in
                    SectorMark(
                        angle: .value("Total", item.totalAmount),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Category", item.category.category))
                    .opacity(selectedCategory == nil || selectedCategory == item.category.category ? 1 : 0.3)
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
                            .font(.headline)
                        Text("Rp\(item.totalAmount, specifier: "%.0f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    } else {
                        Text("Total Income")
                            .font(.subheadline)
                        Text("Rp\(totalIncome, specifier: "%.0f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                        .shadow(radius: 4)
                )
                .allowsHitTesting(false)
            }
        }
        .padding()
    }
}
