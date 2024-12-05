//
//  QueueView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI

struct QueueView: View {
    @State private var searchText = ""
    
    let category: String

    var body: some View {
        ScrollView {
            
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
                Image(systemName: "plus.square.fill")
                    .foregroundStyle(.blue)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
