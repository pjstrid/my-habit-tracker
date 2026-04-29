//
//  StepsViewModel.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import Foundation
import Observation

@Observable
class StepsViewModel {

    var stepsList: [Steps] = [
        Steps(
            id: UUID(),
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 29))!,
            count: 10000
        ),
        Steps(
            id: UUID(),
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 28))!,
            count: 9000
        ),
        Steps(
            id: UUID(),
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 27))!,
            count: 8000
        )
    ]
    
}
