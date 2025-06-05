//
//  mindtraceApp.swift
//  mindtrace
//
//  Created by RC on 4/6/25.
//

import SwiftData
import SwiftUI

@main
struct Application: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Thought.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
