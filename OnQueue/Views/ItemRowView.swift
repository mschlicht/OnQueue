//
//  ItemsList.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import SwiftUI
import CoreData

struct ItemRowView: View {
    var queue: Queue
    @ObservedObject var item: QueueItem
    @Environment(\.managedObjectContext) private var moc
    @Binding var isRatingSheetPresented: Bool
    @Binding var isDeleteItemAlertPresented: Bool
    @Binding var currentItem: QueueItem?
    
    var provider = QueuesProvider.shared
    
    var body: some View {
        
        Section {
            NavigationLink(destination: ItemDetailsView(item: item, queue: queue)) {
                HStack {
                    Text(item.title)
                    Spacer()
                    
                }
            }
        }
        .if(provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue)) { view in
            view
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    currentItem = item
                    isDeleteItemAlertPresented = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
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
                        currentItem = item
                        isRatingSheetPresented = true
                    }
                } label: {
                    Label("Done", systemImage: "checkmark.circle.fill")
                }
                .tint(.green)
            }
        }
    }
    private func delete(_ item: QueueItem) throws {
        let context = provider.viewContext
        let existingItem = try context.existingObject(with: item.objectID)
        context.delete(existingItem)
        try context.save()
//        Task(priority: .background) {
//            try await context.perform {
//                try context.save()
//            }
//        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        apply: (Self) -> Content
    ) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
