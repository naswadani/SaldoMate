//
//  SummaryChartView.swift
//  SaldoMate
//
//  Created by naswakhansa on 07/05/25.
//

import SwiftUI
import Charts

struct SummaryChartView: View {
    let byCategory: [PostCount] = [
      .init(category: "Xcode", count: 79),
      .init(category: "Swift", count: 73),
      .init(category: "SwiftUI", count: 58),
      .init(category: "WWDC", count: 15),
      .init(category: "SwiftData", count: 9),
      .init(category: "C++", count: 9),
      .init(category: "Python", count: 9),
      .init(category: "Golang", count: 9)
    ]
    
    var body: some View {
        Chart(byCategory, id: \.category) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Category", item.category))
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

#Preview {
    SummaryChartView()
}
