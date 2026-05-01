//
//  Habit.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-01.
//

import FirebaseFirestore

struct Habit: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
//    var date: Date
    var count: String
}
