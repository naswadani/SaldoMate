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
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
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
