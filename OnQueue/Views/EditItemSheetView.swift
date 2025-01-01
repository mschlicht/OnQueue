//
//  NewItemSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import SwiftUI

struct EditItemSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFieldFocused: Bool
    @ObservedObject var viewModel: EditItemViewModel
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        NavigationStack() {
            Form {
                TextField("Item Title", text: $viewModel.item.title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                TextField("Item Description", text: $viewModel.item.itemDesc, axis: .vertical)
                    .lineLimit(6)
                Button(viewModel.isNew ? "Create Item" : "Update Item") {
                    
                    do {
                        try viewModel.save()
                    } catch {
                        print(error)
                    }
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(viewModel.item.title.isEmpty)
                .navigationTitle(viewModel.isNew ? "New Item" : "Edit Item")
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
//        .onReceive(NotificationCenter.default.storeDidChangePublisher){_ in }
    }
}

//#Preview {
//    NewItemSheetView()
//}
