//
//  ContentView.swift
//  mindtrace
//
//  Created by RC on 4/6/25.
//

import SwiftData
import SwiftUI

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let numberOfDays = self.dateComponents(
            [.day],
            from: self.startOfDay(for: from),
            to: self.startOfDay(for: to)
        )

        return numberOfDays.day! + 1
    }

    func dateWithoutTime(_ date: Date) -> Date {
        self.date(
            from: self.dateComponents([.year, .month, .day], from: date)
        )!
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    //    @Query private var thoughts: [Thought]

    private var birthday = Calendar.current.date(
        from: DateComponents(year: 1997, month: 8, day: 26)
    )!

    private var days: Range<Int>

    init() {
        let nDays =
            Calendar.current.numberOfDaysBetween(
                self.birthday,
                and: Calendar.current.dateWithoutTime(Date.now)
            ) + 1  // +1 to include today
        self.days = 1..<nDays
    }

    var body: some View {
        NavigationSplitView {
            ScrollViewReader { proxy in
                List {
                    ForEach(self.days, id: \.self) { day in
                        let date = Calendar.current.date(
                            byAdding: .day,
                            value: day - 1,
                            to: self.birthday
                        )!

                        NavigationLink {
                            DayView(day: day, date: date)
                                .navigationTitle("\(String(day))")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(String(day))")
                                    .font(.headline)
                                Text(
                                    date,
                                    format: Date.FormatStyle(
                                        date: .abbreviated,
                                        time: .omitted
                                    )
                                )
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }
                            .fontDesign(.monospaced)
                        }
                        .id(day)
                    }
                }
                .onAppear {
                    proxy.scrollTo(self.days.last, anchor: .bottom)
                }
            }
        } detail: {
            Text("Select a day to begin")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Thought.self, inMemory: true)
}
