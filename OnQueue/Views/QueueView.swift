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
    let queue: Queue
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var isNewItemSheetPresented: Bool = false
    @State private var isUpdateQueueSheetPresented: Bool = false
    @State private var showShareController = false
    @State var sharing = false
    
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
                    if (provider.canEdit(object: queue)) {
                        Button {
                            isUpdateQueueSheetPresented = true
                        } label: {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                    }
                    if (provider.canEdit(object: queue) && provider.isOwner(object: queue)) {
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
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(.blue)
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
//                Button {
//
//                } label: {
//                    Image(systemName: "chart.bar.fill")
//                        .foregroundStyle(.blue)
//                }
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
            NewItemSheetView(viewModel: .init(provider: provider, queue: queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isUpdateQueueSheetPresented) {
            EditQueueSheetView(viewModel: .init(provider: provider, queue:queue))
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showShareController) {
            let share = provider.getShare(queue)!
            CloudSharingView(share: share, container: provider.ckContainer, queue: queue)
                .ignoresSafeArea()
        }
    }
    private func delete(_ queue: Queue) throws {
        let context = provider.viewContext
        let existingQueue = try context.existingObject(with: queue.objectID)
        context.delete(existingQueue)
        try context.save()
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

