//
//  NewQueueSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct NewQueueSheetView: View {
    @State private var name: String = ""
    @State private var selectedColor: String = "Blue"
    @State private var selectedIcon: String = "Circle"
    @State private var selectedGroup: String = "Personal"
    @Environment(\.dismiss) private var dismiss

    let colors = ["Red", "Blue", "Green", "Yellow"]
    let icons = ["Circle", "Star", "Square", "Heart", "Triangle"]
    let groups = ["Personal", "Family", "Roomates"]

    var body: some View {
        ZStack {
            
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing:10) {
                Text("New Queue")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)

                // Name Input Field
                TextField("Enter queue title", text: $name)
                    .padding(.horizontal)
                    .frame(height: 42)
                    .background(.white)
                    .cornerRadius(8)
                
                // Color Picker
                List {
                    Picker("Color", selection: $selectedColor) {
                        ForEach(colors, id: \ .self) { color in
                            Text(color).tag(color)
                        }
                    }
                }
                .scrollDisabled(true)
                .frame(maxHeight: 100)
                .padding(EdgeInsets(top: -30, leading: -20, bottom: -20, trailing: -20))
                .clipShape(Rectangle())
                
                // Icon Picker
                List {
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(icons, id: \ .self) { icon in
                            Text(icon).tag(icon)
                        }
                    }
                }
                .scrollDisabled(true)
                .frame(maxHeight: 100)
                .padding(EdgeInsets(top: -30, leading: -20, bottom: -20, trailing: -20))
                .clipShape(Rectangle())
                
                // Color Picker
                List {
                    Picker("Group", selection: $selectedGroup) {
                        ForEach(groups, id: \ .self) { group in
                            Text(group).tag(group)
                        }
                    }
                }
                .scrollDisabled(true)
                .frame(maxHeight: 100)
                .padding(EdgeInsets(top: -30, leading: -20, bottom: -20, trailing: -20))
                .clipShape(Rectangle())
                
                Button(action: {
                    dismiss()
                }) {
                    Label("Create Queue", systemImage: "plus")
                }
                .padding(.top)
                
            }
            .padding()
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NewQueueSheetView()
}
