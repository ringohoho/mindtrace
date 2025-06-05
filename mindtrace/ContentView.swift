//
//  ContentView.swift
//  mindtrace
//
//  Created by RC on 4/6/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    init() {
    }

    var body: some View {
        TabView {
            DaysView()
                .tabItem {
                    Label("Days", systemImage: "calendar")
                }
            Text("Recent")
                .tabItem {
                    Label("Recent", systemImage: "clock")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Thought.self, inMemory: true)
}
