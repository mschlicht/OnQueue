//
//  NextItemView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/10/24.
//

import SwiftUI

struct NextItemView: View {
    var queue: Queue
    @ObservedObject var item: QueueItem
    //let time: Date
    @Environment(\.managedObjectContext) private var moc
    @State private var dragOffset: CGSize = .zero
    @Binding var isRatingSheetPresented: Bool
    @Binding var isDeleteItemAlertPresented: Bool
    @Binding var isSkipItemAlertPresented: Bool
    @Binding var currentItem: QueueItem?
    @Binding var oldCreatedOn: Date
    
    var provider = QueuesProvider.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: ItemDetailsView(item: item, queue: queue)) {
            ZStack {
                (colorScheme == .dark ? Color(.systemGray6) : .white)
                    .cornerRadius(16)
                    .shadow(color: colorScheme == .light ? Color(.systemGray4) : .clear, radius: colorScheme == .light ? 5 : 0)
                
                Text(item.title)
                    .font(.title)
                    .foregroundStyle(Color.primary)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)
                
                VStack {
                    HStack {
                        Spacer()
                        if (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue)) {
                            Button {
                                currentItem = item
                                isDeleteItemAlertPresented = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .padding()
                            .foregroundStyle(.red)
                        }
                    }
                    Spacer()
                    HStack {
                        if (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue)) {
                            Button {
                                performSwipeAction(.skip, item: item)
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Skip")
                                }
                                .foregroundStyle(.yellow)
                            }
                        }
                        Spacer()
                        //                    Button {
                        //                        hold(item, time: time)
                        //                    } label: {
                        //                        HStack {
                        //                            Text("Hold")
                        //                        }
                        //                        .foregroundStyle(.blue)
                        //                    }
                        //                    Spacer()
                        if (provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue)) {
                            Button {
                                performSwipeAction(.done, item: item)
                            } label: {
                                HStack {
                                    Text("Done")
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundStyle(.green)
                            }
                        }
                    }
                    .padding()
                }
            }
            .offset(x: dragOffset.width, y: dragOffset.height)
            .rotationEffect(.degrees(Double(dragOffset.width / 10)))
            .gesture(
                provider.canEdit(object: queue) && !queue.onlyAdd || provider.isOwner(object: queue) ?
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = CGSize(
                                width: gesture.translation.width,
                                height: max(min(gesture.translation.height, 50), -50)
                            )
                        }
                        .onEnded { _ in
                            if dragOffset.width > 150 {
                                performSwipeAction(.done, item: item)
                            } else if dragOffset.width < -150 {
                                performSwipeAction(.skip, item: item)
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = .zero // Reset position if not swiped far enough
                                }
                            }
                        } : nil
            )
            
        }
        .zIndex(1)
        .buttonStyle(PlainButtonStyle())
    }
//    private func hold(_ item: QueueItem, time: Date) {
//        let newTime = time.addingTimeInterval(0.1)
//        item.createdOn = newTime
//        do {
//            if moc.hasChanges {
//                try moc.save()
//            }
//        } catch {
//            print(error)
//        }
//    }
    private enum SwipeAction {
        case skip, done
    }
    private func performSwipeAction(_ action: SwipeAction, item: QueueItem) {
        withAnimation(.easeOut(duration: 1)) {
            dragOffset = CGSize(width: action == .done ? 1000 : -1000, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dragOffset = .zero
            switch action {
            case .skip:
                oldCreatedOn = item.createdOn
                item.createdOn = Date.now
                do {
                    if moc.hasChanges {
                        try moc.save()
                    }
                } catch {
                    print(error)
                }
                currentItem = item
                isSkipItemAlertPresented = true
            case .done:
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
        }
    }
}
