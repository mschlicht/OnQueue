//
//  EditItemViewModel.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/9/24.
//

import Foundation
import CoreData
import SwiftUI

final class EditItemViewModel: ObservableObject {
    
    @Published var item: QueueItem
    let isNew: Bool
    private let context: NSManagedObjectContext
    
    init(provider: QueuesProvider, item: QueueItem? = nil, queue: Queue) {
        self.context = provider.newContext
        if let item,
           let existingItemCopy = try? context.existingObject(with: item.objectID) as? QueueItem {
            self.item = existingItemCopy
            self.isNew = false
        } else {
            self.item = QueueItem(context: self.context)
            self.isNew = true
            self.item.queue = context.object(with: queue.objectID) as? Queue
        }
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
