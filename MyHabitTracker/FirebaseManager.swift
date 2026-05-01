//
//  FirebaseManager.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-01.
//

import FirebaseFirestore

/// Hanterar alla anrop mot Firestore. Fyll i enligt README (async/await).
final class FirebaseManager {

    var habits: [Habit] = []
    var errorMessage: String?

    private let db = Firestore.firestore()

    func fetchHabits() async -> [Habit] {
        do {
            let snapshot = try await db.collection("habits").getDocuments()

            let habits = snapshot.documents.compactMap { doc -> Habit? in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
                //                guard let date = data["date"] as? Date else { return nil }
                guard let count = data["count"] as? String else { return nil }
                guard let isChecked = data["isChecked"] as? Bool else {
                    return nil
                }

                return Habit(
                    id: doc.documentID,
                    name: name,
                    count: count,
                    isChecked: isChecked
                )
            }
            self.habits = habits
            return habits

        } catch {
            self.errorMessage =
                "Kunde inte hämta: \(error.localizedDescription)"
            return []
        }
    }
    
    func saveHabit(name: String, count: String, isChecked: Bool = false) async {

        let data: [String: Any] = [
            "name": name,
            "count": count,
            "isChecked": isChecked,
            "date": Timestamp(date: Date()),
        ]
        do {
            _ = try await db.collection("habits").addDocument(data: data)
        } catch {
            self.errorMessage =
                "Kunde inte spara: \(error.localizedDescription)"
        }
    }
}
