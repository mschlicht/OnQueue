//
//  EditItemViewModel.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import Foundation
import CoreData

final class EditItemViewModel: ObservableObject {
    
    @Published var item: QueueItem
    
    private let context: NSManagedObjectContext
    
    init(provider: QueuesProvider, item: QueueItem? = nil, queue: Queue) {
        self.context = provider.newContext
        self.item = QueueItem(context: self.context)
        self.item.queue = context.object(with: queue.objectID) as? Queue
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
