//
//  UpdateItemSheet.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/8/24.
//

import SwiftUI

struct UpdateItemSheetView: View {
    let item: QueueItem
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @FocusState private var isTitleFieldFocused: Bool
    @Environment(\.modelContext) private var context
    
    init(item: QueueItem) {
        self.item = item
        _title = State(initialValue: item.title) // Initialize the state variable with item.title
    }
    
    var body: some View {
        NavigationStack() {
            Form {
                TextField("Item Title", text: $title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                Button("Save Updates") {
                    item.title = title
                    try? context.save()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty)
                .navigationTitle("Update Item")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
