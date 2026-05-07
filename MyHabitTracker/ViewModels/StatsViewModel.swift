//
//  StatsViewModel.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-07.
//

import FirebaseFirestore
import Foundation
import Observation

@Observable
class StatsViewModel {

    var statsList: [StatsObject] = []
    var habitNames: [String] = []

    var errorMessage: String?

    private let db = Firestore.firestore()

    func fetchHabitNames() async {

        do {
            let snapshot = try await db.collection("habits").getDocuments()
            let names = snapshot.documents.compactMap {
                $0.data()["name"] as? String
            }
            self.habitNames = names.sorted()
        } catch {
            self.errorMessage =
                "Could not fetch names: \(error.localizedDescription)"
        }
    }

    func fetchStats(name: String) async {
        do {
            let snapshot = try await db.collection("\(name)_statsList")
                .getDocuments()

            let fetchedStatsList = snapshot.documents.compactMap {
                doc -> StatsObject? in
                let data = doc.data()

                guard let timestamp = data["date"] as? Timestamp else {
                    return nil
                }
                guard let statsCount = data["statsCount"] as? Int else {
                    return nil
                }
                guard let unit = data["unit"] as? String else { return nil }
                guard let goal = data["goal"] as? Int else { return nil }

                return StatsObject(
                    id: doc.documentID,
                    date: timestamp.dateValue(),
                    statsCount: statsCount,
                    unit: unit,
                    goal: goal
                )
            }

            self.statsList = fetchedStatsList

        } catch {
            self.errorMessage =
                "Could not fetch: \(error.localizedDescription)"
        }
    }

    func createStatsList(name: String, unit: String, goal: Int) async {

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let data: [String: Any] = [
            "name": name,
            "date": Timestamp(date: today),
            "statsCount": 0,
            "unit": unit,
            "goal": goal
        ]

        do {
            _ = try await db.collection("\(name)_statsList").addDocument(
                data: data
            )
            await fetchStats(name: name)

        } catch {
            self.errorMessage =
                "Could not save: \(error.localizedDescription)"
        }
    }
    
    func updateStatsObject(for name: String, progress: Int, date: Date) async {

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)

        do {
            
            let snapshot = try await db.collection("\(name)_statsList").getDocuments()

            
            let todaysDoc = snapshot.documents.first { doc in
                if let timestamp = doc.data()["date"] as? Timestamp {
                    return calendar.isDate(timestamp.dateValue(), inSameDayAs: today)
                }
                return false
            }

            if let doc = todaysDoc {
                
                try await db.collection("\(name)_statsList")
                    .document(doc.documentID)
                    .updateData([
                        "statsCount": progress
                    ])

            } else {
                
                let unit = statsList.first?.unit ?? ""
                let goal = statsList.first?.goal ?? 0

                let newData: [String: Any] = [
                    "date": Timestamp(date: today),
                    "statsCount": progress,
                    "unit": unit,
                    "goal": goal
                ]

                _ = try await db.collection("\(name)_statsList").addDocument(data: newData)
            }

            await fetchStats(name: name)

        } catch {
            self.errorMessage = "Could not update: \(error.localizedDescription)"
        }
    }
}
