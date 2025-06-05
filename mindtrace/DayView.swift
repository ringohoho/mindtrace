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
            ScrollView {
                VStack(spacing: 0) {
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
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .onTapGesture {
                            self.focusedThought = thought.id
                        }
                    }

                    // TODO: change to "Add" or something
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .id("thoughts-bottom")
                }
                .padding(.vertical, 4)
            }
            .onAppear {
                proxy.scrollTo("thoughts-bottom", anchor: .bottom)
            }
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
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: self.addThought) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    func addThought() {
        let newThought = Thought(day: self.day, content: "")
        modelContext.insert(newThought)
        self.focusedThought = newThought.id
    }
}

#Preview {
    DayView(day: 10145, date: Date.now)
        .modelContainer(for: Thought.self, inMemory: true)
}
