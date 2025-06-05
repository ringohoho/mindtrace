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
    var date: Date  // without time and timezone
    var created: Date
    var updated: Date

    var content: String

    init(date: Date, content: String) {
        self.date = Calendar.current.dateWithoutTime(date)
        self.created = Date.now
        self.updated = Date.now
        self.content = content
    }
}
