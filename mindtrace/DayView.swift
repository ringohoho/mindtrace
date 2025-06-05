//
//  DayView.swift
//  mindtrace
//
//  Created by RC on 5/6/25.
//

import SwiftData
import SwiftUI

struct DayView: View {
    @State private var thoughts: [Thought]
    @Query private var thoughts2: [Thought]

    @FocusState private var focusedThought: Int?

    private var day: Int
    private var date: Date

    init(day: Int, date: Date) {
        self.thoughts = (1...10).map { _ in
            Thought(
                day: day,
                content:
                    "有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思"
            )
        }
        self.day = day
        self.date = date

        self._thoughts2 = Query(
            filter: #Predicate { $0.day == day },
            sort: \.created
        )
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(
                        Array(self.$thoughts.enumerated()),
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
                                text: thought.content,
                                axis: .vertical
                            )
                            .scrollDisabled(true)
                            .focused(
                                self.$focusedThought,
                                equals: index
                            )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .onTapGesture {
                            self.focusedThought = index
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
    }
}

#Preview {
    DayView(day: 10145, date: Date.now)
        .modelContainer(for: Thought.self, inMemory: true)
}
