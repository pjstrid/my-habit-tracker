//
//  StatsObject.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-07.
//

import Foundation

struct StatsObject: Identifiable {
    let id = UUID()
    let date: Date
    let statsCount: Int
    let unit: String
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
