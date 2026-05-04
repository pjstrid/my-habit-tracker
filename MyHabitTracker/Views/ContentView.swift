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
    @State private var newHabitGoal = ""
    @State private var newHabitUnit = ""


    private let firebase = FirebaseManager()

    var body: some View {

        NavigationStack {
            VStack {
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
                                            Text("Goal: \(habit.goal) \(habit.unit)")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .bold()
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            VStack() {
                                                Text("Today")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                    .bold()
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
                                            
                                            VStack() {
                                                Text("Streak")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                    .bold()
                                                Spacer()
                                                Text("🔥3")
                                                    .font(.title3)
                                                    .fontDesign(.rounded)
                                                    .bold()
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Form {
                    Section {
                        TextField("Habit", text: $newHabitName)
                        TextField("Goal", text: $newHabitGoal)
                        TextField("Unit, e.g. 'steps', 'pages'", text: $newHabitUnit)


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
                                newHabitGoal.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                            )
                            .buttonStyle(.glass)
                            .font(Font.title3.bold())
                            Spacer()
                        }
                    } header: {
                        Text("Add new Habit")
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

        guard !newHabitGoal.isEmpty else { return }

        guard !newHabitUnit.isEmpty else { return }
        
        await firebase.saveHabit(name: newHabitName, goal: newHabitGoal, unit: newHabitUnit)
        newHabitName = ""
        newHabitGoal = ""
        newHabitUnit = ""
        await reloadHabits()
    }

}

#Preview {
    ContentView()
}
