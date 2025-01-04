//
//  RatingSheetView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 1/3/25.
//

import SwiftUI

struct RatingSheetView: View {
    var queue: Queue
    @ObservedObject var item: QueueItem
    @State private var selectedRating: Int = 0
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack {
                    Text("Provide a rating for \(item.title)?")
                        .multilineTextAlignment(.center)
                        .frame(width: 400,height:50)
                    HStack(spacing: 10) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(star <= selectedRating ? .yellow : .gray)
                                .onTapGesture {
                                    selectedRating = (selectedRating == star) ? 0 : star
                                }
                        }
                    }
                }
                HStack(spacing: 32) {
                    Button {
                        queue.completed -= 1
                        item.done = false
                        do {
                            if moc.hasChanges {
                                try moc.save()
                            }
                        } catch {
                            print(error)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Cancel")
                        }
                        .foregroundStyle(.red)
                    }
                    Button {
                        item.rating = selectedRating
                        do {
                            if moc.hasChanges {
                                try moc.save()
                            }
                        } catch {
                            print(error)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Text("Done")
                            Image(systemName: "arrow.right")
                        }
                        .foregroundStyle(.green)
                    }
                }
            }
            .padding(.bottom)
            .navigationTitle("Confirm Completion")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
