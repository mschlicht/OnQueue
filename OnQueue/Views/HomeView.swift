//
//  ContentView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI
//import SwiftData

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var isNewQueueSheetPresented: Bool = false
    
    var provider = QueuesProvider.shared
    
    var body: some View {
        NavigationStack {
            QueuesAndGroups(searchText: searchText)
            .padding([.horizontal])
            .navigationTitle("Queues")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("queue")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        
//                    }label: {
//                        Image(systemName: "gear")
//                            .foregroundStyle(.blue)
//                    }
//                }
                ToolbarItemGroup(placement: .bottomBar) {
//                    Button {
//                        
//                    }label: {
//                        Image(systemName: "person.2.badge.plus.fill")
//                            .foregroundStyle(.blue)
//                    }
                    Spacer()
                    Button {
                        isNewQueueSheetPresented = true
                    }label: {
                        Image(systemName: "plus.square.fill.on.square.fill")
                            .foregroundStyle(.blue)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $isNewQueueSheetPresented) {
                EditQueueSheetView(viewModel: .init(provider: provider))
                    .presentationDetents([.large])
            }
        }
    }
}

struct QueuesAndGroups: View {
    //@Query(sort: \Queue.createdOn) private var queues: [Queue]
    @FetchRequest var queues: FetchedResults<Queue>
    @Environment(\.isSearching) private var isSearching
    var searchText: String

    init(searchText: String) {
        _queues = FetchRequest(fetchRequest: Queue.all(searchText: searchText))
        self.searchText = searchText
    }
    
    
    var body: some View {
        ScrollView {
            if queues.isEmpty {
                ContentUnavailableView {
                    VStack {
                        Image("queue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70)
                        Text("Create a queue.")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 196)
                }
            } else {
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing: 32) {
                    ForEach(queues) { queue in
                        NavigationLink(destination: QueueView(queue: queue)) {
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(colorFromDescription(queue.color))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: queue.icon)
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                }
                                
                                Text(queue.title)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .foregroundStyle(Color.primary)
                                Text("\(queue.countItems)")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .padding(.vertical, 32)
            }
//            if !isSearching {
//                VStack() {
//                    Text("Shared Queues")
//                        .foregroundStyle(.secondary)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    VStack() {
//                        Button(action: {}) {
//                            HStack {
//                                Image(systemName: "plus")
//                                    .padding([.horizontal],6)
//                                Text("New Group")
//                            }
//                            .padding([.vertical, .horizontal], 10)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(.white)
//                            .cornerRadius(8)
//                        }
//                    }
//                }
//            }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, QueuesProvider.shared.viewContext)
}
