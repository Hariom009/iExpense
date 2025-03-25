//
//  ContentView.swift
//  iExpense
//
//  Created by Hari's Mac on 22.02.2025.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type : String
    let amount: Double
}
@Observable
class Expenses{
    var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let saveditems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: saveditems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}
struct ContentView: View {
    
    @State private var showingAddExpense = false
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack{
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }, id: \.id) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .fontWeight(item.amount > 1000 ? .bold : .regular)
                        }
                        .padding(13)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(item.amount >= 100 ? Color.red : Color.green)
                        )
                    }
                    .onDelete(perform: removeItems)
                }

                Section("Business") {
                    ForEach(expenses.items.filter { $0.type == "Business" }, id: \.id) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .fontWeight(item.amount > 1000 ? .bold : .regular)
                        }
                        .padding(13)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(item.amount >= 100 ? Color.red : Color.green)
                        )
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .scrollContentBackground(.hidden) // Removes default background from     List
            .background(.white) // Sets the List background to white

            .navigationTitle("iExpense")
            // Date - 25 feb tried to add a new view to add a option to edit the added expense using NavigationLink but cann't
            // 1. Using this also i can add another view other than sheets
//            NavigationLink("ReEdit"){
//                AddView(expenses: expenses)
//            }
            /*
             2. And other way of using this is -- added a extra custom label
             
             NavigationLink{
                AddView(expenses: expenses)
                }label:{
                
             VStack{
             Text("This is a custom label")
             Text("So is this")
             image(systemname:"face.smile")
             }
             .font(.largeTitle)
        }
             
    }
             */
            
           
            .toolbar{
                ToolbarItem(placement:.navigationBarTrailing){
                    NavigationLink {
                        AddView(expenses: expenses)
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
            .toolbar{
                EditButton()
            }
            .ignoresSafeArea(.keyboard)
           }

    }
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
