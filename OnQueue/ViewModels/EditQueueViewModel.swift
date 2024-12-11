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
    
    private let context: NSManagedObjectContext
    
    init(provider: QueuesProvider, queue: Queue? = nil) {
        self.context = provider.newContext
        self.queue = Queue(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
