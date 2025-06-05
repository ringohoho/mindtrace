//
//  Thought.swift
//  mindtrace
//
//  Created by RC on 4/6/25.
//

import Foundation
import SwiftData

@Model
final class Thought {
    var day: Int
    var id: Int
    var content: String
    var deleted: Bool
    
    init(day: Int, id: Int, content: String) {
        self.day = day
        self.id = id
        self.content = content
        self.deleted = false
    }
}
