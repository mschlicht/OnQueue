//
//  ItemDetailsSheet.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/8/24.
//


import SwiftUI

struct ItemDetailsView: View {
    @StateObject var item: QueueItem
    var queue: Queue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @State private var isEditItemSheetPresented: Bool = false
    @State private var isRatingSheetPresented = false
    @State private var isDeleteAlertPresented = false
    
    var provider = QueuesProvider.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
            if item.done {
                HStack(spacing: 10) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < item.rating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(index < item.rating ? .yellow : .gray)
                    }
                }
            }
            Text(item.itemDesc)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding()
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
                            isDeleteAlertPresented = true
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
                                isRatingSheetPresented = true
                            }
                        }label: {
                            Text("Done")
                                .foregroundStyle(.green)
                        }
                    }
                }
                if (item.done && (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue))) {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            isDeleteAlertPresented = true
                        }label: {
                            Text("Delete")
                                .foregroundStyle(.red)
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                do {
                                    queue.completed -= 1
                                    item.done = false
                                    if moc.hasChanges {
                                        try moc.save()
                                    }
                                } catch {
                                    print(error)
                                }
                                dismiss()
                            }
                        }label: {
                            Text("Put Back on Queue")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditItemSheetPresented) {
            EditItemSheetView(viewModel: .init(provider: provider,item:item, queue: queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isRatingSheetPresented) {
            RatingSheetView(queue:queue,item:item)
                .presentationDetents([.height(200)])
        }
        .alert("Are you sure you want to delete \(item.title)?", isPresented: $isDeleteAlertPresented) {
            Button("Delete", role: .destructive) {
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
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Deleting an item will remove it completely.")
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
