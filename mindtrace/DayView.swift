//
//  DayView.swift
//  mindtrace
//
//  Created by RC on 5/6/25.
//

import SwiftData
import SwiftUI

struct DayView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var thoughts: [Thought]

    @FocusState private var focusedThought: UUID?

    private var day: Int
    private var date: Date

    init(day: Int, date: Date) {
        self.day = day
        self.date = date

        self._thoughts = Query(
            filter: #Predicate { $0.day == day },
            sort: \.created
        )
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(
                    Array(self.thoughts.enumerated()),
                    id: \.element.id
                ) { (index, thought) in
                    VStack(spacing: 10) {
                        Text("#\(index + 1)")
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fontDesign(.monospaced)

                        TextField(
                            "",
                            text: Binding(
                                get: { thought.content },
                                set: { thought.content = $0 }
                            ),
                            axis: .vertical
                        )
                        .scrollDisabled(true)
                        .focused(
                            self.$focusedThought,
                            equals: thought.id
                        )
                    }
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        self.focusedThought = thought.id
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            self.deleteThought(thought)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: self.deleteThoughts)

                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .listRowSeparator(.hidden)
                    .id("thoughts-bottom")
            }
            .listStyle(.plain)
            .onChange(of: self.thoughts.count) { old, new in
                if new > old {
                    // is adding, move to bottom
                    proxy.scrollTo("thoughts-bottom", anchor: .bottom)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    self.focusedThought = nil
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: self.addThought) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addThought() {
        let newThought = Thought(day: self.day, content: "")
        modelContext.insert(newThought)
        self.focusedThought = newThought.id
    }

    private func deleteThoughts(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(self.thoughts[index])
        }
    }

    private func deleteThought(_ thought: Thought) {
        modelContext.delete(thought)
    }
}

#Preview {
    DaysView()
        .modelContainer(for: Thought.self, inMemory: true)
}
