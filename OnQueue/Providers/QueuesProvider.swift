//
//  QueuesProvider.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import Foundation
import CoreData
import SwiftUICore

final class QueuesProvider {
    // Only one instance
    static let shared = QueuesProvider()
    
    private let persistentContainer: NSPersistentCloudKitContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init(){
        
        persistentContainer = NSPersistentCloudKitContainer(name: "QueuesDataModel")
        
        guard let description = persistentContainer.persistentStoreDescriptions.first else {
            fatalError("Failed to initialize persistent container")
        }
        
        let cloudKitOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.onqueue.OnQueue")
        description.cloudKitContainerOptions = cloudKitOptions
        
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(filePath: "/dev/null")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        persistentContainer.loadPersistentStores {_, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
}


extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIES"] == "1"
    }
}
