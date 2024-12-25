//
//  NextItemView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/10/24.
//

import SwiftUI

struct NextItemView: View {
    let queue: Queue
    @ObservedObject var item: QueueItem
    //let time: Date
    @Environment(\.managedObjectContext) private var moc
    @State private var dragOffset: CGSize = .zero
    
    var provider = QueuesProvider.shared
    
    var body: some View {
        NavigationLink(destination: ItemDetailsView(item: item)) {
            ZStack {
                Color.white
                    .cornerRadius(16)
                    .shadow(color: Color(.systemGray4), radius: 5)
                
                Text(item.title)
                    .font(.title)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .padding()
                
                VStack {
                    HStack {
                        Spacer()
                        if (provider.canEdit(object: queue)) {
                            Button {
                                withAnimation {
                                    do {
                                        try delete(item)
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .padding()
                            .foregroundStyle(.red)
                        }
                    }
                    Spacer()
                    HStack {
                        if (provider.canEdit(object: queue)) {
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
                        if (provider.canEdit(object: queue)) {
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
                provider.canEdit(object: queue) ?
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
                item.createdOn = Date.now
                do {
                    if moc.hasChanges {
                        try moc.save()
                    }
                } catch {
                    print(error)
                }
            case .done:
                queue.completed += 1
                do {
                    try delete(item)
                    if moc.hasChanges {
                        try moc.save()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}


// Ellipse Menu

//Menu {
//    Button {
//
//    } label: {
//        Text("Details")
//        Image(systemName: "text.page.badge.magnifyingglass")
//    }
//    Button {
//        
//    } label: {
//        Text("Edit")
//        Image(systemName: "pencil")
//    }
//    Button {
//        withAnimation {
//            do {
//                try delete(item)
//            } catch {
//                print(error)
//            }
//        }
//    } label: {
//        Text("Delete")
//        Image(systemName: "trash")
//    }
//} label: {
//    Image(systemName: "ellipsis")
//        .foregroundStyle(.blue)
//        .padding()
//}
