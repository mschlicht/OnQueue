//
//  QueueView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import CloudKit
import CoreData
import Foundation
import SwiftUI
import UIKit

struct QueueView: View {
    @ObservedObject var queue: Queue
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var isNewItemSheetPresented: Bool = false
    @State private var isUpdateQueueSheetPresented: Bool = false
    @State private var isUpdatePermissionsSheetPresented: Bool = false
    @State private var showShareController = false
    @State private var isRatingSheetPresented = false
    @State private var isDeleteQueueAlertPresented = false
    @State private var isDeleteItemAlertPresented = false
    @State private var isSkipItemAlertPresented = false
    @State private var currentItem: QueueItem? = nil
    @State private var oldCreatedOn: Date = Date.now
    @State var sharing = false
    
    var provider = QueuesProvider.shared
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        QueueItemsView(queue:queue, searchText: searchText, isRatingSheetPresented: $isRatingSheetPresented, isDeleteItemAlertPresented: $isDeleteItemAlertPresented, isSkipItemAlertPresented: $isSkipItemAlertPresented, currentItem: $currentItem, oldCreatedOn: $oldCreatedOn)
        .padding([.horizontal])
        .navigationTitle(queue.title)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        if provider.isShared(object: queue) {
                            showShareController = true
                        } else {
//                            openSharingController(queue: queue)
                            Task.detached {
                                await createShare(queue)
                            }
                        }
                    } label: {
                        Text("Share")
                        Image(systemName: "square.and.arrow.up")
                    }
                    NavigationLink(destination: QueueDetailsView(queue: queue), label: {
                        Text("Completed")
                        Image(systemName: "text.page.badge.magnifyingglass")
                    })
                    if (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue)) {
                        Button {
                            isUpdateQueueSheetPresented = true
                        } label: {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                    }
                    if (provider.isOwner(object: queue)) {
                        Button {
                            isDeleteQueueAlertPresented = true
                        } label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(.blue)
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                if (provider.isShared(object: queue) && provider.isOwner(object: queue)){
                    Button {
                        isUpdatePermissionsSheetPresented = true
                    } label: {
                        Image(systemName: "person.2.badge.gearshape")
                            .foregroundStyle(.blue)
                    }
                }
                Spacer()
                if (provider.canEdit(object: queue)) {
                    Button {
                        isNewItemSheetPresented = true
                    } label: {
                        Image(systemName: "plus.square.fill")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $isNewItemSheetPresented) {
            EditItemSheetView(viewModel: .init(provider: provider, queue: queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isUpdateQueueSheetPresented) {
            EditQueueSheetView(viewModel: .init(provider: provider, queue:queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isUpdatePermissionsSheetPresented) {
            EditPermissionsView(viewModel: .init(provider: provider, queue:queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showShareController) {
            let share = provider.getShare(queue)!
            CloudSharingView(share: share, container: provider.ckContainer, queue: queue)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isRatingSheetPresented) {
            RatingSheetView(queue:queue,item:currentItem!)
                .presentationDetents([.height(200)])
        }
        .alert("Are you sure you want to delete \(queue.title)?", isPresented: $isDeleteQueueAlertPresented) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    do {
                        try delete(queue)
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Deleting a queue will remove it and all of its items completely.")
        }
        .alert("Are you sure you want to delete \(currentItem?.title ?? "this item")?", isPresented: $isDeleteItemAlertPresented) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    do {
                        try delete(currentItem!)
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Deleting an item will remove it completely.")
        }
        .alert("Are you sure you want to skip \(currentItem?.title ?? "this item")?", isPresented: $isSkipItemAlertPresented) {
            Button("Yes") {}
            Button("Cancel", role: .cancel) {
                withAnimation {
                    currentItem?.createdOn = oldCreatedOn
                    do {
                        if moc.hasChanges {
                            try moc.save()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        } message: {
            Text("Skipping an item will move it to the back of the queue.")
        }
    }
    private func delete(_ queue: Queue) throws {
        let context = provider.viewContext
        let existingQueue = try context.existingObject(with: queue.objectID)
        context.delete(existingQueue)
        try context.save()
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
    
    func createShare(_ queue: Queue) async {
        sharing = true
        do {
            let (_, share, _) = try await provider.persistentContainer.share([queue], to: nil)
            share[CKShare.SystemFieldKey.title] = queue.title
        } catch {
            print("Faile to create share")
            sharing = false
        }
        sharing = false
        showShareController = true
    }
    
//    private func openSharingController(queue: Queue) {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter { $0.activationState == .foregroundActive }
//            .map { $0 as? UIWindowScene }
//            .compactMap { $0 }
//            .first?.windows
//            .filter { $0.isKeyWindow }.first
//
//        let sharingController = UICloudSharingController {
//            (_, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
//
//            provider.persistentContainer.share([queue], to: nil) { _, share, container, error in
//                if let actualShare = share {
//                    queue.managedObjectContext?.performAndWait {
//                        actualShare[CKShare.SystemFieldKey.title] = queue.title
//                    }
//                }
//                completion(share, container, error)
//            }
//        }
//
//        keyWindow?.rootViewController?.present(sharingController, animated: true)
//    }
}

