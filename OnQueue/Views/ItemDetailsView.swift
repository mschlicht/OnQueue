//
//  ItemDetailsSheet.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/8/24.
//


import SwiftUI

struct ItemDetailsView: View {
    @ObservedObject var item: QueueItem
    let queue: Queue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @State private var isEditItemSheetPresented: Bool = false
    
    var provider = QueuesProvider.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.itemDesc)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding()
        .navigationTitle(item.title)
        .toolbar {
            if (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue)) {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditItemSheetPresented = true
                    }label: {
                        Text("Edit")
                    }
                }
                if (!item.done && (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue))) {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            withAnimation {
                                do {
                                    try delete(item)
                                    if moc.hasChanges {
                                        try moc.save()
                                    }
                                } catch {
                                    print(error)
                                }
                                dismiss()
                            }
                        }label: {
                            Text("Delete")
                                .foregroundStyle(.red)
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                queue.completed += 1
                                item.done = true
                                item.completedOn = Date.now
                                do {
                                    if moc.hasChanges {
                                        try moc.save()
                                    }
                                } catch {
                                    print(error)
                                }
                                dismiss()
                            }
                        }label: {
                            Text("Done")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditItemSheetPresented) {
            EditItemSheetView(viewModel: .init(provider: provider,item:item, queue: queue))
                .presentationDetents([.large])
        }
        .background(Color(.systemGroupedBackground))
    }
    private func delete(_ item: QueueItem) throws {
        let context = provider.viewContext
        let existingItem = try context.existingObject(with: item.objectID)
        context.delete(existingItem)
        try context.save()
    }
}
