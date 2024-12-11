//
//  UpdateQueueSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import SwiftUI

struct UpdateQueueSheetView: View {
    let queue: Queue
    
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var selectedColor: String
    @State private var selectedIcon: String
    @State private var selectedGroup: String
    @FocusState private var isTitleFieldFocused: Bool
    
    init(queue: Queue) {
        self.queue = queue
        _title = State(initialValue: queue.title)
        _selectedColor = State(initialValue: queue.color)
        _selectedIcon = State(initialValue: queue.icon)
        _selectedGroup = State(initialValue: queue.group)
    }

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
                Button("Save Changes") {
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty)
                .navigationTitle("Update Queue")
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
    UpdateQueueSheetView(queue: Queue.preview())
}
