//
//  QueueView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI
import SwiftData

struct QueueView: View {
    let queue: Queue
    @State private var searchText = ""
    @State private var isNewItemSheetPresented: Bool = false

    var body: some View {
        QueueItemsView(queue:queue)
        .padding([.horizontal])
        .navigationTitle(queue.title)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "gear")
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
            NewItemSheetView(queue: queue)
                .presentationDetents([.large])
        }
    }
}

struct QueueItemsView: View {
    let queue: Queue
    @Environment(\.isSearching) private var isSearching
    @Environment(\.modelContext) private var context
    @State private var searchText = ""
    @State private var dragOffset: CGSize = .zero
    @State private var isRemovingFirstItem: Bool = false
    @State private var isDeletingListItem: Bool = false

    var body: some View {
        let items = queue.items?.sorted(using: KeyPathComparator(\QueueItem.createdOn)) ?? []
        VStack(spacing: 16) {
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
                                            Text("Update")
                                            Image(systemName: "arrow.trianglehead.2.clockwise")
                                        }
                                        Button {
                                            withAnimation(.spring) {
                                                isDeletingListItem = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                context.delete(item)
                                                queue.count -= 1
                                                try? context.save()
                                                isDeletingListItem = false
                                            }
                                        } label: {
                                            Text("Delete")
                                            Image(systemName: "trash")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    withAnimation(.spring) {
                                        isDeletingListItem = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        context.delete(item)
                                        queue.count -= 1
                                        try? context.save()
                                        isDeletingListItem = false
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash") // Label with a trash icon and "Delete" text
                                }
                                .tint(.red) // Set the swipe action background to red
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    withAnimation(.spring) {
                                        isDeletingListItem = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        context.delete(item)
                                        queue.count -= 1
                                        queue.completed += 1
                                        try? context.save()
                                        isDeletingListItem = false
                                    }
                                } label: {
                                    Label("Done", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .padding()
                            .background(.white)
                        }
                    }
                    .opacity(isDeletingListItem ? 0 : 1)
                    .scaleEffect(isDeletingListItem ? 0.75 : 1)
                    .contentMargins(.vertical, 0)
                    .contentMargins(.horizontal, 1)
                    .listSectionSpacing(8)
                    .padding(.top,8)
                } else {
                    // Swipeable card for the first item
                    if let firstItem = items.first {
                        ZStack {
                            Color.white // Background color
                                .cornerRadius(16)
                                .shadow(color: Color(.systemGray4), radius: 5)
                            
                            Text(firstItem.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Menu {
                                        Button {
                                            
                                        } label: {
                                            Text("Details")
                                            Image(systemName: "text.page.badge.magnifyingglass")
                                        }
                                        Button {
                                            
                                        } label: {
                                            Text("Update")
                                            Image(systemName: "arrow.trianglehead.2.clockwise")
                                        }
                                        Button {
                                            deleteFirstItem(firstItem: firstItem)
                                        } label: {
                                            Text("Delete")
                                            Image(systemName: "trash")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(.blue)
                                            .padding()
                                    }
                                }
                                Spacer()
                                HStack {
                                    Button {
                                        // Skip action
                                        performSwipeAction(.skip, firstItem: firstItem)
                                    } label: {
                                        HStack {
                                            Image(systemName: "arrow.left")
                                            Text("Skip")
                                        }
                                        .foregroundStyle(.yellow)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        // Done action
                                        performSwipeAction(.done, firstItem: firstItem)
                                    } label: {
                                        HStack {
                                            Text("Done")
                                            Image(systemName: "arrow.right")
                                        }
                                        .foregroundStyle(.green)
                                    }
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Square size
                        .offset(x: dragOffset.width, y: dragOffset.height)
                        .rotationEffect(.degrees(Double(dragOffset.width / 10))) // Rotate slightly
                        .opacity(isRemovingFirstItem ? 0 : 1) // Fade out animation
                        .scaleEffect(isRemovingFirstItem ? 0.75 : 1) // Slight shrink animation
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    dragOffset = CGSize(
                                        width: gesture.translation.width,
                                        height: max(min(gesture.translation.height, 50), -50)
                                    )
                                }
                                .onEnded { _ in
                                    if dragOffset.width > 150 {
                                        performSwipeAction(.done, firstItem: firstItem)
                                    } else if dragOffset.width < -150 {
                                        performSwipeAction(.skip, firstItem: firstItem)
                                    } else {
                                        withAnimation(.spring()) {
                                            dragOffset = .zero // Reset position if not swiped far enough
                                        }
                                    }
                                }
                        )
                        .zIndex(1) // Ensure this view is above others
                    }
                    if items.dropFirst().isEmpty {
                        Rectangle()
                            .foregroundStyle(Color(.systemGroupedBackground))
                    } else {
                        List {
                            ForEach(items.dropFirst()) { item in
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
                                                Text("Update")
                                                Image(systemName: "arrow.trianglehead.2.clockwise")
                                            }
                                            Button {
                                                withAnimation(.spring) {
                                                    isDeletingListItem = true
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                    context.delete(item)
                                                    queue.count -= 1
                                                    try? context.save()
                                                    isDeletingListItem = false
                                                }
                                            } label: {
                                                Text("Delete")
                                                Image(systemName: "trash")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        withAnimation(.spring) {
                                            isDeletingListItem = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            context.delete(item)
                                            queue.count -= 1
                                            try? context.save()
                                            isDeletingListItem = false
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash") // Label with a trash icon and "Delete" text
                                    }
                                    .tint(.red) // Set the swipe action background to red
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        withAnimation(.spring) {
                                            isDeletingListItem = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            context.delete(item)
                                            queue.count -= 1
                                            queue.completed += 1
                                            try? context.save()
                                            isDeletingListItem = false
                                        }
                                    } label: {
                                        Label("Done", systemImage: "checkmark.circle.fill")
                                    }
                                    .tint(.green)
                                }
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .padding()
                                .background(.white)
                            }
                        }
                        .opacity(isDeletingListItem ? 0 : 1)
                        .scaleEffect(isDeletingListItem ? 0.75 : 1)
                        .contentMargins(.vertical, 0)
                        .contentMargins(.horizontal, 1)
                        .listSectionSpacing(8)
                        .zIndex(0)
                    }
                }
            }
        }
    }
    private func deleteFirstItem(firstItem: QueueItem) {
        withAnimation(.easeOut(duration: 0.5)) {
            isRemovingFirstItem = true // Trigger animation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Delay removal until animation completes
            context.delete(firstItem)
            queue.count -= 1
            try? context.save()
            isRemovingFirstItem = false // Reset state for subsequent actions
        }
    }
    private enum SwipeAction {
        case skip, done
    }
    private func performSwipeAction(_ action: SwipeAction, firstItem: QueueItem) {
        withAnimation(.easeOut(duration: 1)) {
            dragOffset = CGSize(width: action == .done ? 1000 : -1000, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dragOffset = .zero
            switch action {
            case .skip:
                firstItem.createdOn = Date.now // Reschedule item
                try? context.save()
            case .done:
                queue.completed += 1
                context.delete(firstItem) // Remove item
                queue.count -= 1
                try? context.save()
            }
        }
    }
}

