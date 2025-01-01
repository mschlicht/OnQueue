//
//  NewQueueSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct EditQueueSheetView: View {
    @ObservedObject var viewModel: EditQueueViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFieldFocused: Bool
    
//    var provider = QueuesProvider.shared

    let colors: [String] = ["Blue", "Red", "Orange", "Yellow", "Green", "Mint", "Teal", "Cyan", "Indigo", "Purple", "Pink", "Brown"]
    let groups = ["Personal", "Family", "Roomates"]
    let icons: [(name: String, systemImage: String)] = [
        ("Default", "square.stack.3d.up.fill"),
        ("Popcorn", "popcorn.fill"),
        ("Movie Clapper", "movieclapper.fill"),
        ("Game Controller", "gamecontroller.fill"),
        ("TV", "tv.fill"),
        ("Map", "map.fill"),
        ("Location", "location.fill"),
        ("Clipboard", "list.clipboard.fill"),
        ("Books", "books.vertical.fill"),
        ("Walk", "figure.walk"),
        ("Run", "figure.run"),
        ("Social Activity", "figure.socialdance"),
        ("Food", "fork.knife")
    ]


    var body: some View {
        NavigationStack() {
            Form {
                TextField("Queue Title", text: $viewModel.queue.title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                Picker("Color", selection: $viewModel.queue.color) {
                    ForEach(colors, id: \ .self) { color in
                        Text(color).tag(color)
                    }
                }
                .foregroundStyle(colorFromDescription(viewModel.queue.color))
                Picker("Icon", selection: $viewModel.queue.icon) {
                    ForEach(icons, id: \.systemImage) { icon in
                        Label(icon.name, systemImage: icon.systemImage)
                            .tag(icon.systemImage)
                    }
                }
//                if (provider.isShared(object: viewModel.queue) && provider.isOwner(object: viewModel.queue)){
//                    Toggle(isOn: $viewModel.queue.onlyAdd) {
//                        Label {
//                            Text("Participants can only add")
//                        } icon: {
//                            
//                        }
//                    }
//                    .tint(.blue)
//                }
                Button(viewModel.isNew ? "Create Queue" : "Update Queue") {
//                    let newQueue = Queue(title: title,color: selectedColor.description, icon: selectedIcon, group: selectedGroup)
//                    context.insert(newQueue)
//                    try? context.save()
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
                .disabled(viewModel.queue.title.isEmpty)
                .navigationTitle(viewModel.isNew ? "New Queue" : "Edit Queue")
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
    EditQueueSheetView(viewModel: .init(provider: .shared))
}
