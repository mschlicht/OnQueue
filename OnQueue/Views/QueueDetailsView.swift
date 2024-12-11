//
//  QueueDetailsView.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/10/24.
//

import SwiftUI

struct QueueDetailsView: View {
    let queue: Queue
    
    var body: some View {
        List {
            Text("\(queue.completed)")
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .principal) {
                ZStack {
                    Circle()
                        .fill(colorFromDescription(queue.color))
                        .frame(width: 40, height: 40)
                    Image(systemName: queue.icon)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        QueueDetailsView(queue: Queue.preview())
    }
}
