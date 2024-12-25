//
//  Queue.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import Foundation
import CoreData

final class Queue: NSManagedObject, Identifiable {
    @NSManaged var title: String
    @NSManaged var color: String
    @NSManaged var icon: String
    @NSManaged var completed: Int
    @NSManaged var createdOn: Date
    @NSManaged var onlyAdd: Bool
    
    @NSManaged var items:NSSet?
    
    // Defaults on Create
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue("Blue", forKey: "color")
        setPrimitiveValue("square.stack.3d.up.fill", forKey: "icon")
        setPrimitiveValue(Date.now, forKey: "createdOn")
        setPrimitiveValue(0, forKey: "completed")
        setPrimitiveValue([], forKey: "items")
        setPrimitiveValue(false, forKey: "onlyAdd")
    }
}

extension Queue {
    
    var countItems: Int {
        let itemsSet = items as? Set<QueueItem> ?? []
        return itemsSet.filter { !$0.done }.count
    }
    
    var sortedItems: [QueueItem] {
        let itemsSet = items as? Set<QueueItem> ?? []
        return itemsSet.sorted(using: KeyPathComparator(\QueueItem.createdOn))
    }
    
    private static var queueFetchRequest: NSFetchRequest<Queue> {
        NSFetchRequest(entityName: "Queue")
    }
    
    static func all() -> NSFetchRequest<Queue> {
        let request: NSFetchRequest<Queue> = queueFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Queue.createdOn, ascending: false)
        ]
        return request
    }
    
}

extension Queue {
    @discardableResult
    static func makePreview(count: Int, in context:NSManagedObjectContext) -> [Queue] {
        var queues = [Queue]()
        for i in 0..<count {
            let queue = Queue(context: context)
            queue.title = "Queue \(i)"
            queue.icon = "square.stack.3d.up.fill"
            queue.color = "Blue"
            queue.createdOn = Date.now
            queue.completed = 0
            queue.items = []
            queues.append(queue)
        }
        return queues
    }
    
    static func preview(context: NSManagedObjectContext = QueuesProvider.shared.viewContext) -> Queue {
        return makePreview(count: 1, in: context)[0]
    }
    
    static func empty(context: NSManagedObjectContext = QueuesProvider.shared.viewContext) -> Queue {
        return Queue(context: context)
    }
}
