//
//  ContentView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import SwiftUI

struct ContentView: View {

    @State private var habits: [Habit] = []

    @State private var newHabitName = ""
    @State private var newHabitCount = ""

    private let firebase = FirebaseManager()

    var body: some View {

        NavigationStack {
            VStack {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(.black),
                            Color(red: 0.1, green: 0.15, blue: 0.1),
                        ],
                        startPoint: .bottom,
                        endPoint: .topTrailing
                    )
                    .ignoresSafeArea()

                    List {
                        Section {
                            if habits.isEmpty {
                                ContentUnavailableView(
                                    "No tracked habits yet",
                                    systemImage: "xmark.circle",
                                    description: Text(
                                        "Add a tracked habit to get started!"
                                    )
                                )
                            } else {
                                ForEach($habits) { $habit in

                                    HStack {
                                        VStack(alignment: .leading, spacing: 6)
                                        {
                                            Text(habit.name)
                                                .font(.title3)
                                                .fontDesign(.rounded)
                                                .bold()
                                            Text("Today: \(habit.count)")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .bold()
                                        }
                                        Spacer()
                                        Button {
                                            habit.isChecked.toggle()
                                        } label: {
                                            Image(
                                                systemName: habit.isChecked
                                                    ? "checkmark.circle.fill"
                                                    : "circle"
                                            )
                                            .font(.system(size: 26))
                                            .foregroundColor(
                                                habit.isChecked
                                                    ? .green.opacity(0.6)
                                                    : .gray
                                            )
                                        }
                                        .buttonStyle(.plain)

                                    }
                                }
                            }
                        }
                    }
                }

                Form {
                    Section {
                        TextField("Habit", text: $newHabitName)
                        TextField("Count", text: $newHabitCount)

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
                            )
                            .disabled(
                                newHabitCount.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                            )
                            .buttonStyle(.glass)
                            .font(Font.title3.bold())
                            Spacer()
                        }
                    } header: {
                        Text("Add progress")
                    }
                }
            }
            .navigationTitle("My Habit Tracker")
            .task {
                await reloadHabits()
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func reloadHabits() async {
        habits = await firebase.fetchHabits()
    }

    private func saveNewHabit() async {

        guard !newHabitName.isEmpty else { return }

        guard !newHabitCount.isEmpty else { return }

        await firebase.saveHabit(name: newHabitName, count: newHabitCount)
        newHabitName = ""
        newHabitCount = ""
        await reloadHabits()
    }

}

#Preview {
    ContentView()
}
