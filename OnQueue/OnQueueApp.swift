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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
