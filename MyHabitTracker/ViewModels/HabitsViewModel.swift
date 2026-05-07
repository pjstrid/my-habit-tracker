//
//  HabitsViewModel.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-01.
//

import FirebaseFirestore
import Foundation
import Observation

@Observable
class HabitsViewModel {

    var habits: [Habit] = []
    var errorMessage: String?

    private let db = Firestore.firestore()

    func fetchHabits() async {
        do {
            let snapshot = try await db.collection("habits").getDocuments()

            let habits = snapshot.documents.compactMap { doc -> Habit? in
                let data = doc.data()

                guard let name = data["name"] as? String else { return nil }
                guard let goal = data["goal"] as? Int else { return nil }
                guard let unit = data["unit"] as? String else { return nil }
                guard let progress = data["progress"] as? Int else {
                    return nil
                }

                let completedDates =
                    (data["completedDates"] as? [Timestamp])?.map {
                        $0.dateValue()
                    } ?? []

                return Habit(
                    id: doc.documentID,
                    name: name,
                    goal: goal,
                    unit: unit,
                    completedDates: completedDates,
                    progress: progress
                )
            }

            self.habits = habits

        } catch {
            self.errorMessage =
                "Could not fetch: \(error.localizedDescription)"
        }
    }

    func saveHabit(name: String, goal: Int, unit: String) async {

        let data: [String: Any] = [
            "name": name,
            "goal": goal,
            "unit": unit,
            "completedDates": [],
            "progress": 0,
        ]

        do {
            _ = try await db.collection("habits").addDocument(data: data)
            await fetchHabits()
        } catch {
            self.errorMessage =
                "Could not save: \(error.localizedDescription)"
        }
    }

    func toggleToday(for habit: Habit) async {

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let isCompletedToday = habit.completedDates.contains {
            calendar.isDate($0, inSameDayAs: today)
        }

        do {
            if isCompletedToday {
                try await db.collection("habits").document(habit.id)
                    .updateData([
                        "completedDates": FieldValue.arrayRemove([
                            Timestamp(date: today)
                        ])
                    ])
            } else {
                try await db.collection("habits")
                    .document(habit.id)
                    .updateData([
                        "completedDates": FieldValue.arrayUnion([
                            Timestamp(date: today)
                        ])
                    ])
            }
            await fetchHabits()
        } catch {
            self.errorMessage =
                "Could not update: \(error.localizedDescription)"
        }
    }

    func deleteHabit(at offsets: IndexSet) async {

        for index in offsets {
            let habit = habits[index]

            do {
                try await db.collection("habits")
                    .document(habit.id)
                    .delete()
            } catch {
                self.errorMessage =
                    "Could not delete: \(error.localizedDescription)"
            }
        }
        await fetchHabits()
    }

    func addProgress(for habit: Habit, addedProgress: Int) async {

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let newProgress = /*habit.progress +*/ addedProgress

        let reachedGoal = newProgress >= habit.goal

        do {

            try await db.collection("habits")
                .document(habit.id)
                .updateData([
                    "progress": newProgress
                ])

            if reachedGoal {
                try await db.collection("habits")
                    .document(habit.id)
                    .updateData([
                        "completedDates": FieldValue.arrayUnion([
                            Timestamp(date: today)
                        ])
                    ])
            }

            if !reachedGoal
                && habit.completedDates.contains(where: {
                    calendar.isDate($0, inSameDayAs: today)
                })
            {
                try await db.collection("habits")
                    .document(habit.id)
                    .updateData([
                        "completedDates": FieldValue.arrayRemove([
                            Timestamp(date: today)
                        ])
                    ])
            }

            await fetchHabits()
            
        } catch {
            self.errorMessage =
                "Could not update: \(error.localizedDescription)"
        }
    }

}
