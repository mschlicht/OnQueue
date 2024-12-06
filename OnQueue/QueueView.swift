//
//  QueueView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct QueueView: View {
    @State private var searchText = ""
    @State private var newItem = ""
    @State private var isNewItemSheetPresented: Bool = false
    @State private var dragOffset: CGSize = .zero
    
    let category: String
    
    let items = [
        "Good Will Hunting",
        "Inglorious Bastards",
        "Inception",
        "Fight Club",
        "Ace Ventura"
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Swipeable card for the first item
            if let firstItem = items.first {
                ZStack {
                    Color.blue.opacity(0.1) // Background color
                        .cornerRadius(16)
                    Text(firstItem)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                .frame(width: 300, height: 300) // Square size
                .offset(x: dragOffset.width, y: dragOffset.height)
                .rotationEffect(.degrees(Double(dragOffset.width / 10))) // Rotate slightly
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation
                        }
                        .onEnded { _ in
                            if abs(dragOffset.width) > 150 {
                                // Perform action when swiped
                                withAnimation {
                                    dragOffset = CGSize(width: dragOffset.width > 0 ? 500 : -500, height: 0)
                                }
                                // Reset the card or update the list after swipe
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    dragOffset = .zero
                                    // Logic to handle the swiped card (e.g., remove it)
                                }
                            } else {
                                withAnimation {
                                    dragOffset = .zero // Reset position if not swiped far enough
                                }
                            }
                        }
                )
                .padding(.top)
            }
            
            // Scroll view for the remaining items
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items.dropFirst(), id: \.self) { item in
                        Text(item)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .padding([.horizontal])
        .navigationTitle(category)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Edit")
                    .foregroundStyle(.blue)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    isNewItemSheetPresented = true
                }label: {
                    Image(systemName: "plus.square.fill")
                        .foregroundStyle(.blue)
                }
            }
            
        }
        .sheet(isPresented: $isNewItemSheetPresented) {
            NewItemSheetView()
                .presentationDetents([.large])
        }
    }
}
