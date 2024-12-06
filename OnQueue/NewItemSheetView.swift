//
//  NewItemSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import SwiftUI

struct NewItemSheetView: View {
    @State private var title: String = ""
    @FocusState private var isTitleFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack() {
            Form {
                TextField("Item Title", text: $title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                Button("Create Queue") {
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty)
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

#Preview {
    NewItemSheetView()
}
