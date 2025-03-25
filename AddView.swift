//
//  AddView.swift
//  iExpense
//
//  Created by Hari's Mac on 24.02.2025.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
     let types = ["Business", "Personal"]
    @FocusState private var isFocused: Bool
    // Here maine is view k variable expenses me Observed class Expenses access ki h
    var expenses: Expenses
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                    .focused($isFocused)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount , format: .currency(code:"INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Expense")
            .toolbar{
                Button("Save"){
                    expenses.items.append(ExpenseItem(name: name, type: type, amount: amount))
                        dismiss()
                }
                Button("Go back"){
                    isFocused = false
                    dismiss()
                }
            }
            .onAppear{
                    isFocused = true
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
