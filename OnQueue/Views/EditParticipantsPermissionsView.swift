//
//  EditParticipantsPermissionsView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/31/24.
//

import SwiftUI

struct EditPermissionsView: View {
    @ObservedObject var viewModel: EditQueueViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFieldFocused: Bool
    
    var provider = QueuesProvider.shared

    var body: some View {
        NavigationStack() {
            Form {
                if (provider.isShared(object: viewModel.queue) && provider.isOwner(object: viewModel.queue)){
                    Toggle(isOn: $viewModel.queue.onlyAdd) {
                        Label {
                            Text("Participants can only add")
                        } icon: {
                            
                        }
                    }
                    .tint(.blue)
                }
                Button("Update Permissions") {
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
                .navigationTitle("Edit Share Permissions")
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

