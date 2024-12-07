//
//  Item.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import Foundation
import SwiftData

@Model
class QueueItem {
    var title: String
    var createdOn: Date
    
    init(
        title: String,
        createdOn: Date = Date.now
    ) {
        self.title = title
        self.createdOn = createdOn
    }
    @Relationship
    var queue: Queue?
}
