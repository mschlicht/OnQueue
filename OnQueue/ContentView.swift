//
//  ContentView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Queue.createdOn) private var queues: [Queue]
    @State private var searchText: String = ""
    @State private var isNewQueueSheetPresented: Bool = false
    @State private var isEditing: Bool = false

    let categories = [
        ("Movies", "10"),
        ("Restaurants", "12"),
        ("Shows", "5"),
        ("Boardgames", "8")
    ]

    let colors: [Color] = [
        .blue, .green, .yellow, .teal, .red, .orange
    ]

    let icons = [
        "film.fill",
        "fork.knife",
        "tv.fill",
        "gamecontroller.fill"
    ]

    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    if queues.isEmpty {
                        ContentUnavailableView("Create your first queue.", systemImage: "square.stack.3d.up.fill")
                            .padding()
                    } else {
                        LazyVGrid(columns: gridColumns, spacing: 20) {
                            ForEach(queues) { queue in
                                NavigationLink(destination: QueueView(category: queue.title)) {
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
                                            .foregroundStyle(.black)
                                        Text("5")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                        .padding([.vertical])
                    }
                }
                VStack() {
                    Text("Shared Groups")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack() {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "plus")
                                    .padding([.horizontal],6)
                                Text("New Group")
                            }
                            .padding([.vertical, .horizontal], 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding([.horizontal])
            .navigationTitle("Queues")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    }label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.blue)
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        
                    }label: {
                        Image(systemName: "person.2.badge.plus.fill")
                            .foregroundStyle(.blue)
                    }
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
                NewQueueSheetView()
                    .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Queue.self, inMemory: true)
}
