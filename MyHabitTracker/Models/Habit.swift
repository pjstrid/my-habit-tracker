//
//  Habit.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-01.
//

import Foundation

struct Habit: Identifiable, Codable {
    var id: String
    var name: String
    var goal: Int
    var unit: String
    var completedDates: [Date] = []
    var progress: Int
}

extension Habit {
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDates.contains { date in
            calendar.isDateInToday(date)
        }
    }
}

extension Habit {
    var currentStreak: Int {
        let calendar = Calendar.current

        let uniqueDays = Set(
            completedDates.map { calendar.startOfDay(for: $0) }
        )
        let sortedDays = uniqueDays.sorted(by: >)

        guard let latest = sortedDays.first else {
            return 0
        }

        let today = calendar.startOfDay(for: Date())

        let daysSinceLatest =
            calendar.dateComponents([.day], from: latest, to: today).day ?? 0

        if daysSinceLatest > 1 {
            return 0
        }

        var streak = 1
        var expected = calendar.date(byAdding: .day, value: -1, to: latest)!

        for day in sortedDays.dropFirst() {
            if day == expected {
                streak += 1
                expected = calendar.date(
                    byAdding: .day,
                    value: -1,
                    to: expected
                )!
            } else {
                break
            }
        }

        return streak
    }
}
