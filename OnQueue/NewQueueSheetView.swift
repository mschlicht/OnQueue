//
//  NewQueueSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct NewQueueSheetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var selectedColor: String = "Blue"
    @State private var selectedIcon: String = "square.stack.3d.up.fill"
    @State private var selectedGroup: String = "Personal"
    @FocusState private var isTitleFieldFocused: Bool

    let colors: [String] = ["Red", "Orange", "Yellow", "Green", "Mint", "Teal", "Cyan", "Blue", "Indigo", "Purple", "Pink", "Brown"]
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
                TextField("Queue Title", text: $title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                Picker("Color", selection: $selectedColor) {
                    ForEach(colors, id: \ .self) { color in
                        Text(color).tag(color)
                    }
                }
                .foregroundStyle(colorFromDescription(selectedColor))
                Picker("Icon", selection: $selectedIcon) {
                    ForEach(icons, id: \.systemImage) { icon in
                        Label(icon.name, systemImage: icon.systemImage)
                            .tag(icon.systemImage)
                    }
                }
                Picker("Group", selection: $selectedGroup) {
                    ForEach(groups, id: \ .self) { group in
                        Text(group).tag(group)
                    }
                }
                Button("Create Queue") {
                    let newQueue = Queue(title: title,color: selectedColor.description, icon: selectedIcon, group: selectedGroup)
                    context.insert(newQueue)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty)
                .navigationTitle("New Queue")
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
    NewQueueSheetView()
}
