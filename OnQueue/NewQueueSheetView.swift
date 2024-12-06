//
//  NewQueueSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct NewQueueSheetView: View {
    @State private var title: String = ""
    @State private var selectedColor: String = "Blue"
    @State private var selectedIcon: String = "Circle"
    @State private var selectedGroup: String = "Personal"
    @FocusState private var isTitleFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss

    let colors = ["Red", "Blue", "Green", "Yellow"]
    let icons = ["Circle", "Star", "Square", "Heart", "Triangle"]
    let groups = ["Personal", "Family", "Roomates"]

    var body: some View {
        NavigationStack() {
            Form {
                TextField("Queue Title", text: $title)
                    .focused($isTitleFieldFocused)
                    .onAppear{isTitleFieldFocused = true}
                Picker("Color", selection:$selectedColor) {
                    ForEach(colors, id: \ .self) { color in
                        Text(color).tag(color)
                    }
                }
                Picker("Icon", selection: $selectedIcon) {
                    ForEach(icons, id: \ .self) { icon in
                        Text(icon).tag(icon)
                    }
                }
                Picker("Group", selection: $selectedGroup) {
                    ForEach(groups, id: \ .self) { group in
                        Text(group).tag(group)
                    }
                }
                Button("Create Queue") {
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
