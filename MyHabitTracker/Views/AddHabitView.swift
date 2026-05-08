//
//  AddHabitView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-04.
//

import SwiftUI

struct AddHabitView: View {
    @Binding var isPresented: Bool

    @State private var newHabitName = ""
    @State private var newHabitGoal = ""
    @State private var newHabitUnit = ""

    @Bindable var habitsVM: HabitsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.black),
                        Color(red: 0.1, green: 0.20, blue: 0.1),
                    ],
                    startPoint: .center,
                    endPoint: .topTrailing
                )
                .ignoresSafeArea()

                Form {
                    Section {
                        TextField("Habit", text: $newHabitName)
                            .onChange(of: newHabitName) { _, newValue in
                                newHabitName = newValue.replacingOccurrences(
                                    of: " ",
                                    with: ""
                                )
                            }

                        TextField("Goal", text: $newHabitGoal)
                            .keyboardType(.numberPad)

                        TextField(
                            "Unit ('steps', 'pages', 'minutes')",
                            text: $newHabitUnit
                        )

                        HStack {
                            Spacer()
                            Button {
                                Task {
                                    await saveNewHabit()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Save")
                                        .padding(10)
                                }
                            }
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
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: { habitsVM.errorMessage != nil },
                set: {
                    if !$0 {
                        habitsVM.errorMessage = nil
                    }
                }
            ),
            presenting: habitsVM.errorMessage
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }

    func saveNewHabit() async {

        guard
            !newHabitName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
        else {
            habitsVM.errorMessage = "Habit name cannot be empty"
            return
        }

        guard let goalConverted = Int(newHabitGoal), goalConverted > 0 else {
            habitsVM.errorMessage = "Goal must be a valid number"
            return
        }

        guard !newHabitUnit.isEmpty else {
            habitsVM.errorMessage = "Habit unit cannot be empty"
            return }

        await habitsVM.saveHabit(
            name: newHabitName,
            goal: goalConverted,
            unit: newHabitUnit
        )

        newHabitName = ""
        newHabitGoal = ""
       newHabitUnit = ""

        await reloadHabits()

        isPresented = false
    }

    func reloadHabits() async {
        await habitsVM.fetchHabits()
    }
}
