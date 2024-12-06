//
//  QueueView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct QueueView: View {
    let category: String
    
    @State private var searchText = ""
    @State private var newItem = ""
    @State private var isNewItemSheetPresented: Bool = false
    @State private var dragOffset: CGSize = .zero
    
    let items = [
        "Good Will Hunting",
        "Inglorious Bastards",
        "Inception",
        "Fight Club",
        "Ace Ventura",
        "Dead Poets Society"
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Swipeable card for the first item
            if let firstItem = items.first {
                ZStack {
                    Color.white // Background color
                        .cornerRadius(16)
                        .shadow(color: Color(.systemGray4), radius: 5)
                    
                    Text(firstItem)
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
                                withAnimation {
                                    dragOffset = CGSize(width: -500, height: 0)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    dragOffset = .zero
                                    // Logic to handle skip
                                }
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
                                withAnimation {
                                    dragOffset = CGSize(width: 500, height: 0)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    dragOffset = .zero
                                    // Logic to handle done
                                }
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
                .frame(width: 300, height: 300) // Square size
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
                .zIndex(1) // Ensure this view is above others
            }
            
            // Scroll view for the remaining items
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items.dropFirst(), id: \.self) { item in
                        HStack {
                            Text(item)
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
                        .padding(.horizontal)
                    }
                }
            }
            .zIndex(0) // Ensure this view is behind the swipeable card
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
                Button {
                    
                }label: {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundStyle(.blue)
                }
                Spacer()
                Button {
                    isNewItemSheetPresented = true
                }label: {
                    Image(systemName: "plus.square.fill")
                        .foregroundStyle(.blue)
                }
            }
            
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $isNewItemSheetPresented) {
            NewItemSheetView()
                .presentationDetents([.large])
        }
    }
}

#Preview {
    QueueView(category: "Movies")
}
