//
//  SummaryChartViewModel.swift
//  SaldoMate
//
//  Created by naswakhansa on 31/05/25.
//


import Foundation
import SwiftUI

final class SummaryChartViewModel: ObservableObject {
    
    let chartData: [SummaryModel]
    
    init(chartData: [SummaryModel]) {
        self.chartData = chartData
    }
    
    var totalIncome: Double {
        chartData.reduce(0) { $0 + $1.totalAmount }
    }
    
    
    
    
}
