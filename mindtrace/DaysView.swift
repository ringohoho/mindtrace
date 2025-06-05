//
//  DaysView.swift
//  mindtrace
//
//  Created by RC on 5/6/25.
//

import SwiftData
import SwiftUI

struct DaysView: View {
    @Environment(\.modelContext) private var modelContext

    private var birthday = Calendar.current.date(
        from: DateComponents(year: 1997, month: 8, day: 26)
    )!
    private var days: Range<Int>

    @State private var selectedDay: Int?

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
                List(
                    self.days.reversed(),
                    id: \.self,
                    selection: self.$selectedDay
                ) {
                    day in
                    let date = Calendar.current.date(
                        byAdding: .day,
                        value: day - 1,
                        to: self.birthday
                    )!

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
            }
            .navigationTitle("Days")
        } detail: {
            if let day = self.selectedDay {
                let date = Calendar.current.date(
                    byAdding: .day,
                    value: day - 1,
                    to: self.birthday
                )!
                DayView(day: day, date: date)
                    .navigationTitle("\(String(day))")
            } else {
                Text("Select a day to begin")
            }
        }
    }
}

#Preview {
    DaysView()
        .modelContainer(for: Thought.self, inMemory: true)
}
