//
//  OnQueueApp.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/5/24.
//

import SwiftUI
//import SwiftData

@main
struct OnQueueApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, QueuesProvider.shared.viewContext)
        }
//        .modelContainer(for: Queue.self)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
