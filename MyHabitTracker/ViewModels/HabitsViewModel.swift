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
                guard let goal = data["goal"] as? String else { return nil }
                guard let unit = data["unit"] as? String else { return nil }

                let completedDates =
                    (data["completedDates"] as? [Timestamp])?.map {
                        $0.dateValue()
                    } ?? []

                return Habit(
                    id: doc.documentID,
                    name: name,
                    goal: goal,
                    unit: unit,
                    completedDates: completedDates
                )
            }

            self.habits = habits

        } catch {
            self.errorMessage =
                "Could not fetch: \(error.localizedDescription)"
        }
    }

    func saveHabit(name: String, goal: String, unit: String) async {

        let data: [String: Any] = [
            "name": name,
            "goal": goal,
            "unit": unit,
            "completedDates": [],
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
            
            do { try await db.collection("habits")
                    .document(habit.id)
                    .delete()
            } catch {
                self.errorMessage =
                "Could not delete: \(error.localizedDescription)"
            }
        }
        await fetchHabits()
    }

}
