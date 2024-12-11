//
//  ItemsList.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import SwiftUI
import CoreData

struct ItemRowView: View {
    let queue: Queue
    let item: QueueItem
    @Environment(\.managedObjectContext) private var moc
    
    var provider = QueuesProvider.shared
    
    var body: some View {
        Section {
            HStack {
                Text(item.title)
                Spacer()
                Menu {
                    Button {
                        
                    } label: {
                        Text("Details")
                        Image(systemName: "text.page.badge.magnifyingglass")
                    }
                    Button {
                        
                    } label: {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                    Button {
                        withAnimation {
                            do {
                                try delete(item)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Delete")
                        Image(systemName: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.blue)
                        .frame(width: 30, height: 20, alignment: .center)
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                withAnimation {
                    do {
                        try delete(item)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                queue.completed += 1
                withAnimation {
                    do {
                        try delete(item)
                        if moc.hasChanges {
                            try moc.save()
                        }
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Label("Done", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)
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
