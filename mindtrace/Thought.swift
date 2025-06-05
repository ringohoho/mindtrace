//
//  Thought.swift
//  mindtrace
//
//  Created by RC on 4/6/25.
//

import Foundation
import SwiftData

@Model
final class Thought: Identifiable {
    var id = UUID()
    var day: Int
    var created: Date
    var updated: Date

    var content: String

    init(day: Int, content: String) {
        self.day = day
        self.created = Date.now
        self.updated = Date.now
        self.content = content
    }
}
