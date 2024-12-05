//
//  NewQueueSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct NewQueueSheetView: View {
    @State private var name: String = ""
    @FocusState private var nameFieldIsFocused: Bool

    @State private var selectedGroup: String = "Personal"
    @State private var selectedIcon: String = "film.fill"
    @State private var selectedColor: Color = .blue

    let groups = ["Personal", "Work", "Shared"]
    let icons = ["film.fill", "fork.knife", "tv.fill", "gamecontroller.fill"]
    let colors: [Color] = [.blue, .green, .yellow, .teal, .red, .orange]

    var body: some View {
        ZStack {
            // Background tap to dismiss keyboard
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    nameFieldIsFocused = false // Dismiss keyboard
                }

            VStack(spacing: 20) {
                Text("New Queue")
                    .font(.title)
                    .bold()
                    .padding(.top)

                // Name Input Field
                TextField("Enter queue name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($nameFieldIsFocused)
                    .onAppear {
                        nameFieldIsFocused = true
                    }

                // Group Selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Group")
                        .font(.headline)
                    Picker("Group", selection: $selectedGroup) {
                        ForEach(groups, id: \.self) { group in
                            Text(group).tag(group)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // Icon Selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Icon")
                        .font(.headline)
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(icons, id: \.self) { icon in
                            HStack {
                                Image(systemName: icon)
                                Text(icon)
                            }
                            .tag(icon)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // Color Selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Color")
                        .font(.headline)
                    Picker("Color", selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 20, height: 20)
                                Text(color.description.capitalized)
                            }
                            .tag(color)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
