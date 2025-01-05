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
    
    @State private var selectedRating: Int = 0

    var body: some View {
        NavigationStack() {
            Form {
                TextField("Item Title", text: $viewModel.item.title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                TextField("Item Description", text: $viewModel.item.itemDesc, axis: .vertical)
                    .lineLimit(6)
                if viewModel.item.done {
                    HStack(spacing: 10) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(star <= selectedRating ? .yellow : .gray)
                                .onTapGesture {
                                    selectedRating = (selectedRating == star) ? 0 : star
                                }
                        }
                    }
                }
                Button(viewModel.isNew ? "Create Item" : "Update Item") {
                    viewModel.item.rating = selectedRating
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
