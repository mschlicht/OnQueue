//
//  ContentView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isNewQueueSheetPresented: Bool = false

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
                    LazyVGrid(columns: gridColumns, spacing: 20) {
                        ForEach(categories.indices, id: \ .self) { index in
                            NavigationLink(destination: QueueView(category: categories[index].0)) {
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(colors[index % colors.count])
                                            .frame(width: 60, height: 60)

                                        Image(systemName: icons[index])
                                            .foregroundStyle(.white)
                                            .font(.title2)
                                    }
                                    
                                    Text(categories[index].0)
                                        .foregroundStyle(.black)
                                    Text(categories[index].1)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .padding([.vertical])
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
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Edit")
                            .foregroundStyle(.blue)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "gear")
                            .foregroundStyle(.blue)
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Image(systemName: "person.2.badge.plus.fill")
                            .foregroundStyle(.blue)
                        Spacer()
                        Image(systemName: "plus.square.fill.on.square.fill")
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                isNewQueueSheetPresented = true
                            }
                    }
                }
                .background(Color(.systemGroupedBackground))
                .sheet(isPresented: $isNewQueueSheetPresented) {
                    NewQueueSheetView()
                }
            }
    }
}

#Preview {
    ContentView()
}
