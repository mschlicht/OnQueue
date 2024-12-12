//
//  EditQueueViewModel.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import Foundation
import CoreData

final class EditQueueViewModel: ObservableObject {
    
    @Published var queue: Queue
    let isNew: Bool
    private let context: NSManagedObjectContext
    
    init(provider: QueuesProvider, queue: Queue? = nil) {
        self.context = provider.newContext
        if let queue,
           let existingQueueCopy = try? context.existingObject(with: queue.objectID) as? Queue {
            self.queue = existingQueueCopy
            self.isNew = false
        } else {
            self.queue = Queue(context: self.context)
            self.isNew = true
        }
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
