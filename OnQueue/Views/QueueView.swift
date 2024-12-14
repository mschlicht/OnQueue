//
//  QueueView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI
import CoreData

struct QueueView: View {
    let queue: Queue
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var isNewItemSheetPresented: Bool = false
    @State private var isUpdateQueueSheetPresented: Bool = false
    
    var provider = QueuesProvider.shared
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        QueueItemsView(queue:queue)
        .padding([.horizontal])
        .navigationTitle(queue.title)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink(destination: QueueDetailsView(queue: queue), label: {
                        Text("Details")
                        Image(systemName: "text.page.badge.magnifyingglass")
                    })
                    Button {
                        isUpdateQueueSheetPresented = true
                    } label: {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                    Button {
                        withAnimation {
                            do {
                                try delete(queue)
                                dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Delete")
                        Image(systemName: "trash")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(.blue)
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button {

                } label: {
                    Image(systemName: "chart.bar.fill")
                        .foregroundStyle(.blue)
                }
                Spacer()
                Button {
                    isNewItemSheetPresented = true
                } label: {
                    Image(systemName: "plus.square.fill")
                        .foregroundStyle(.blue)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $isNewItemSheetPresented) {
            NewItemSheetView(viewModel: .init(provider: provider, queue: queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isUpdateQueueSheetPresented) {
            EditQueueSheetView(viewModel: .init(provider: provider, queue:queue))
                .presentationDetents([.large])
        }
    }
    private func delete(_ queue: Queue) throws {
        let context = provider.viewContext
        let existingQueue = try context.existingObject(with: queue.objectID)
        context.delete(existingQueue)
        try context.save()
    }
}

