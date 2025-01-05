//
//  QueueItemsView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/10/24.
//

import SwiftUI

struct QueueItemsView: View {
    @ObservedObject var queue: Queue
    @Environment(\.isSearching) private var isSearching
    @FetchRequest private var items: FetchedResults<QueueItem>
    @Binding var isRatingSheetPresented: Bool
    @Binding var isDeleteItemAlertPresented: Bool
    @Binding var isSkipItemAlertPresented: Bool
    @Binding var currentItem: QueueItem?
    @Binding var oldCreatedOn: Date
    var searchText: String
        
    init(queue: Queue, searchText: String, isRatingSheetPresented: Binding<Bool>, isDeleteItemAlertPresented: Binding<Bool>, isSkipItemAlertPresented: Binding<Bool>,currentItem: Binding<QueueItem?>, oldCreatedOn: Binding<Date>) {
        self.queue = queue
        self.searchText = searchText
        self._currentItem = currentItem
        self._items = FetchRequest(fetchRequest: QueueItem.sortedQueueItemsPending(for: queue, searchText: searchText))
        self._isRatingSheetPresented = isRatingSheetPresented
        self._isDeleteItemAlertPresented = isDeleteItemAlertPresented
        self._isSkipItemAlertPresented = isSkipItemAlertPresented
        self._oldCreatedOn = oldCreatedOn
    }

    var body: some View {
        if items.isEmpty {
            ContentUnavailableView {
                VStack {
                    Image(systemName: queue.icon)
                        .font(.system(size: 48))
                        .foregroundStyle(colorFromDescription(queue.color))
                    Text("Create an item.")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        } else {
            if isSearching {
                List {
                    ForEach(items) { item in
                        ItemRowView(queue:queue,item: item,isRatingSheetPresented:$isRatingSheetPresented, isDeleteItemAlertPresented: $isDeleteItemAlertPresented,currentItem: $currentItem)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding()
                }
                .contentMargins(.vertical, 0)
                .contentMargins(.horizontal, 1)
                .listSectionSpacing(8)
                .padding(.top,8)
            } else {
                if let firstItem = items.first {
                    NextItemView(queue: queue, item: firstItem, isRatingSheetPresented: $isRatingSheetPresented, isDeleteItemAlertPresented: $isDeleteItemAlertPresented, isSkipItemAlertPresented: $isSkipItemAlertPresented, currentItem: $currentItem, oldCreatedOn: $oldCreatedOn)
//                    if items.count > 1 {
//                        NextItemView(queue: queue, item: firstItem, time: items[1].createdOn)
//                    } else {
//                        NextItemView(queue: queue, item: firstItem, time: firstItem.createdOn)
//                    }
                }
                if items.dropFirst().isEmpty {
                    Rectangle()
                        .foregroundStyle(Color(.systemGroupedBackground))
                } else {
                    List {
                        ForEach(items.dropFirst()) { item in
                            ItemRowView(queue:queue,item: item,isRatingSheetPresented:$isRatingSheetPresented, isDeleteItemAlertPresented: $isDeleteItemAlertPresented,currentItem: $currentItem)
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding()
                    }
                    .contentMargins(.vertical, 0)
                    .contentMargins(.horizontal, 1)
                    .listSectionSpacing(8)
                    .padding(.top,8)
                }
            }
        }
    }
}
