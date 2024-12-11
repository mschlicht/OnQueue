//
//  Item.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import Foundation
import CoreData

final class QueueItem: NSManagedObject, Identifiable {
    @NSManaged var title: String
    @NSManaged var createdOn: Date
    
    @NSManaged var queue: Queue
    
    // Defaults on Create
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "createdOn")
    }
}

extension QueueItem {
    
    private static var itemFetchRequest: NSFetchRequest<QueueItem> {
        NSFetchRequest(entityName: "QueueItem")
    }
    
    static func sortedQueueItems(for queue:Queue) -> NSFetchRequest<QueueItem> {
        let request: NSFetchRequest<QueueItem> = itemFetchRequest
        // Set a predicate to filter by the provided queue
        request.predicate = NSPredicate(format: "queue == %@", queue)
        
        // Sort items by creation date
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \QueueItem.createdOn, ascending: true)
        ]
        return request
    }
    
}

//import Foundation
//import SwiftData

//@Model
//class QueueItem {
//    var title: String
//    var createdOn: Date
//    
//    init(
//        title: String,
//        createdOn: Date = Date.now
//    ) {
//        self.title = title
//        self.createdOn = createdOn
//    }
//    var queue: Queue?
//}
