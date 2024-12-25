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
            HStack {
                Text("Completed")
                Spacer()
                Text("\(queue.completed)")
            }
            
        }
        .navigationTitle("Details")
    }
}

#Preview {
    NavigationStack {
        QueueDetailsView(queue: Queue.preview())
    }
}
