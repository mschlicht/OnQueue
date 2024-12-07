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
    @Environment(\.modelContext) private var context
    @State private var searchText = ""
    @State private var newItem = ""
    @State private var isNewItemSheetPresented: Bool = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        VStack(spacing: 16) {
            let items = queue.items?.sorted(using: KeyPathComparator(\QueueItem.createdOn)) ?? []
            // Swipeable card for the first item
            Group {
                if items.isEmpty {
                    ContentUnavailableView("Create your first item.", systemImage: "square.stack.3d.up.fill")
                        .padding()
                } else {
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
                                    Button {
                                        // Ellipsis action
                                        print("Ellipsis tapped")
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
                    
                    // Scroll view for the remaining items
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(items.dropFirst()) { item in
                                HStack {
                                    Text(item.title)
                                    Spacer()
                                    Button {
                                        isNewItemSheetPresented = true
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .zIndex(0) // Ensure this view is behind the swipeable card
                }
            }
        }
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
                    Image(systemName: "arrow.uturn.backward")
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
            case .done:
                queue.completed += 1
                context.delete(firstItem) // Remove item
                queue.count -= 1
            }
        }
    }
}

