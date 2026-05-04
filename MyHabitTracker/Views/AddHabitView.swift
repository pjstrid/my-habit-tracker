//
//  AddHabitView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-04.
//

import SwiftUI

struct AddHabitView: View {
    @Binding var habits: [Habit]
    @Binding var isPresented: Bool

    @State private var newHabitName = ""
    @State private var newHabitGoal = ""
    @State private var newHabitUnit = ""

    private let firebase = FirebaseManager()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.black),
                        Color(red: 0.1, green: 0.20, blue: 0.1),
                    ],
                    startPoint: .bottom,
                    endPoint: .topTrailing
                )
                .ignoresSafeArea()

                Form {
                    Section {
                        TextField("Habit", text: $newHabitName)
                        TextField("Goal", text: $newHabitGoal)
                        TextField(
                            "Unit, e.g. 'steps', 'pages'",
                            text: $newHabitUnit
                        )

                        HStack {
                            Spacer()
                            Button {
                                Task { await saveNewHabit() }
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Save")
                                        .padding(10)
                                }
                            }
                            .disabled(
                                newHabitName.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                                    || newHabitGoal.trimmingCharacters(
                                        in: .whitespacesAndNewlines
                                    ).isEmpty
                                    || newHabitUnit.trimmingCharacters(
                                        in: .whitespacesAndNewlines
                                    ).isEmpty
                            )
                            .buttonStyle(.glass)
                            .font(Font.title3.bold())
                            Spacer()
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Add new habit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }

    func saveNewHabit() async {

        guard !newHabitName.isEmpty else { return }

        guard !newHabitGoal.isEmpty else { return }

        guard !newHabitUnit.isEmpty else { return }

        await firebase.saveHabit(
            name: newHabitName,
            goal: newHabitGoal,
            unit: newHabitUnit
        )
        newHabitName = ""
        newHabitGoal = ""
        newHabitUnit = ""
        await reloadHabits()
    }

    func reloadHabits() async {
        habits = await firebase.fetchHabits()
    }
}
