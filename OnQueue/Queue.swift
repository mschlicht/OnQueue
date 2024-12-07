//
//  Queue.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import Foundation
import SwiftData

@Model
class Queue {
    var title: String
    var color: String
    var icon:  String
    var group: String
    var count: Int
    var completed: Int
    var createdOn: Date
    @Relationship(deleteRule: .cascade)
    var items: [QueueItem]?
    
    init(
        title: String,
        color: String,
        icon: String,
        group: String,
        createdOn: Date = Date.now,
        completed: Int = 0,
        count: Int = 0
    ) {
        self.title = title
        self.color = color
        self.icon = icon
        self.group = group
        self.createdOn = createdOn
        self.completed = completed
        self.count = count
    }
}
