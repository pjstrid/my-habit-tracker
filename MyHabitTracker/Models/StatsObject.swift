//
//  StatsObject.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-07.
//

import Foundation

struct StatsObject: Identifiable, Codable {
    var id: String = UUID().uuidString
    var date: Date
    var statsCount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
