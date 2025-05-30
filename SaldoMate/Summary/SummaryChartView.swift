//
//  SummaryChartView.swift
//  SaldoMate
//
//  Created by naswakhansa on 07/05/25.
//

import SwiftUI
import Charts

struct SummaryChartView: View {
    var chartData: [(categoryName: String, totalAmount: Double)] = []
    
    var body: some View {
        Chart(chartData, id: \.categoryName) { item in
            SectorMark(
                angle: .value("Count", item.totalAmount),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Category", item.categoryName))
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 16)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    Text("Categories")
                        .font(.caption)
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding()
    }
}
