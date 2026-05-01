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

    // TODO: Lägg till en `private let db`-property som pekar på Firestore.
    // Rekommendation: `private let db = Firestore.firestore()` — se README ("Var ska db ligga?").

    private let db = Firestore.firestore()

    /// Hämtar alla dokument i kollektionen `notes` och gör om dem till `CloudNote`.
    func fetchHabits() async -> [Habit] {
        do {
            let snapshot = try await db.collection("habits").getDocuments()

            let habits = snapshot.documents.compactMap { doc -> Habit? in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
//                guard let date = data["date"] as? Date else { return nil }
                guard let count = data["count"] as? String else { return nil }

                return Habit(id: doc.documentID, name: name, /*date: date,*/ count: count)
            }
            self.habits = habits
            return habits

        } catch {
            self.errorMessage =
                "Kunde inte hämta: \(error.localizedDescription)"
            return []
        }

    }

    /// Sparar en ny anteckning som ett nytt dokument i kollektionen `notes`.
    func saveHabit(name: String, count: String) async {

        let data: [String: Any] = [
            "name": name,
            "count": count,
            "date": Timestamp(date: Date())
        ]
        do {
            _ = try await db.collection("habits").addDocument(data: data)
        } catch {
            self.errorMessage =
                "Kunde inte spara: \(error.localizedDescription)"
        }
    }
}

