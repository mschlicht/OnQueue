//
//  QueueDetailsView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/10/24.
//

import SwiftUI

struct QueueDetailsView: View {
    let queue: Queue
    @FetchRequest private var items: FetchedResults<QueueItem>
        
    init(queue: Queue) {
        self.queue = queue
        self._items = FetchRequest(fetchRequest: QueueItem.sortedQueueItemsDone(for: queue))
    }
    
    var body: some View {
        VStack {
            if items.isEmpty {
                ContentUnavailableView {
                    VStack {
                        Image(systemName: queue.icon)
                            .font(.system(size: 48))
                            .foregroundStyle(colorFromDescription(queue.color))
                        Text("No completed items.")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
            } else {
                List {
                    ForEach(items) { item in
                        Section {
                            NavigationLink(destination: ItemDetailsView(item: item, queue: queue)) {
                                HStack {
                                    Text(item.title)
                                    Spacer()
                                    if(item.rating != 0) {
                                        Text(String(item.rating))
                                        Image(systemName:"star.fill")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                        }
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding()
                }
                .contentMargins(.vertical, 0)
                .contentMargins(.horizontal, 1)
                .listSectionSpacing(8)
                .padding(.top,8)
                .padding([.horizontal])
            }
        }
        .navigationTitle("Completed")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Text("Total Completed: \(queue.completed)")
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        QueueDetailsView(queue: Queue.preview())
    }
}
