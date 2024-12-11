//
//  NewItemSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import SwiftUI

struct NewItemSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFieldFocused: Bool
    @ObservedObject var viewModel: EditItemViewModel

    var body: some View {
        NavigationStack() {
            Form {
                TextField("Item Title", text: $viewModel.item.title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                Button("Create Item") {
                    
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
                .navigationTitle("New Item")
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

//#Preview {
//    NewItemSheetView()
//}
