//
//  SaldoMateApp.swift
//  SaldoMate
//
//  Created by naswakhansa on 04/05/25.
//

import SwiftUI

@main
struct SaldoMateApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.background
        
        appearance.stackedLayoutAppearance.selected.iconColor = .textPrimary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
