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
    @FocusState private var focusedThought: Int?

    private var day: Int
    private var date: Date

    init(day: Int, date: Date) {
        self.thoughts = (1...10).map {
            Thought(
                day: day,
                id: $0,
                content:
                    "有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思有点意思"
            )
        }
        self.day = day
        self.date = date
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(self.$thoughts, id: \.id) { thought in
                            VStack(spacing: 10) {
                                Text("#\(thought.id)")
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
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("\(String(self.day))")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        self.focusedThought = nil
                    }
                }
            }
            //            .toolbar {
            //                ToolbarItem(placement: .topBarTrailing) {
            //                    Button("Add") {
            //
            //                    }
            //                }
            //            }
        }
    }
}

#Preview {
    DayView(day: 10145, date: Date.now)
        .modelContainer(for: Thought.self, inMemory: true)
}
