//
//  Queue.swift
//  OnQueue
//
//  Created by Miguel Schlicht on 12/6/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Queue {
    var title: String
    var color: String
    var icon:  String
    var group: String
    var createdOn: Date
    
    init(
        title: String,
        color: String,
        icon: String,
        group: String,
        createdOn: Date = Date.now
    ) {
        self.title = title
        self.color = color
        self.icon = icon
        self.group = group
        self.createdOn = createdOn
    }
}
