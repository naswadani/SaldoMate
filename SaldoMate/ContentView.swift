//
//  ContentView.swift
//  SaldoMate
//
//  Created by naswakhansa on 04/05/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        TabView {
            TransactionView(repository: TransactionRepository(context: context))
                .tabItem {
                    Label("Transactions", systemImage: "arrow.trianglehead.2.counterclockwise")
                }
            SummaryView(repository: SummaryRepository(context: context))
                .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
            SettingsView(repository: CategoryListRepository(context: context))
                .tabItem {
                    Label("Preferences", systemImage: "gearshape")
                }
        }
        .tint(.white)
        .environment(\.managedObjectContext, context)
    }
}


#Preview {
    ContentView()
}
