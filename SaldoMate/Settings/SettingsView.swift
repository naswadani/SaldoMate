//
//  SettingsView.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentasionMode
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    private let repository: CategoryListRepositoryProtocol
    
    init(repository: CategoryListRepositoryProtocol) {
        self.repository = repository
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing : 20){
                    //MARK : INFORMATION
                    GroupBox(
                        label:
                            SettingsLabelView(
                                labelText: "Saldo Mate",
                                labelImage: "info.circle"
                            )
                    ){
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack(alignment: .center, spacing: 10){
                            Image("saldoMateLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(9)
                            Text("SaldoMate: A lightweight, offline personal finance tracker for effortless income and expense recording, prioritizing simplicity and user privacy.")
                                .fontDesign(.default)
                                .font(.footnote)
                                .foregroundStyle(.textPrimary)
                        }
                    }
                    
                    //MARK : APPEARANCE
                    GroupBox(
                        label:
                            SettingsLabelView(
                                labelText: "Appearance",
                                labelImage: "paintpalette.fill"
                            )
                    ) {
                        Divider().padding(.vertical, 4)
                        Toggle(isOn : $isDarkMode){
                            Text("dark mode".uppercased())
                                .fontWeight(.bold)
                                .foregroundStyle(.textSecondary)
                            
                        }
                        .tint(.incomeLabel)
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius:  8, style: .continuous))
                        )
                    }
                    
                    //MARK : CATEGORY
                    GroupBox(
                        label: SettingsLabelView(
                            labelText: "Category",
                            labelImage: "list.clipboard.fill"
                        )
                    ) {
                        Divider().padding(.vertical, 4)
                        NavigationLink(destination: CategoryListView(
                            repository: repository, selectedType: .income
                        )) {
                            HStack {
                                Text("Income List")
                                    .fontDesign(.default)
                                    .foregroundStyle(.textSecondary)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.down.left")
                                    .foregroundStyle(.incomeLabel)
                            }
                        }
                        Divider().padding(.vertical, 4)
                        NavigationLink(destination: CategoryListView(
                            repository: repository, selectedType: .expense
                        )) {
                            HStack {
                                Text("Expense List")
                                    .fontDesign(.default)
                                    .foregroundStyle(.textSecondary)
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .foregroundStyle(.expenseLabel)
                            }
                        }
                        
                    }
                    
                    //MARK : ABOUT
                    GroupBox(
                        label:
                            SettingsLabelView(
                                labelText: "About",
                                labelImage: "apps.iphone"
                            )
                    ){
                        SettingsRowView(
                            name: "Developer",
                            content: "Naswa Bryna Danikhansa"
                        )
                        SettingsRowView(
                            name: "Compatibility",
                            content: "iOS 16.6")
                        SettingsRowView(
                            name : "Version",
                            content : "1.0.0"
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView(repository: CategoryListRepository(context: PersistenceController.shared.container.viewContext))
}
