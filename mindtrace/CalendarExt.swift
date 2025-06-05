//
//  CalendarExt.swift
//  mindtrace
//
//  Created by RC on 5/6/25.
//

import Foundation

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
