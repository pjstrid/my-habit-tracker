//
//  ContentView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import SwiftUI

struct ContentView: View {

    @State private var showingAddHabitSheet = false

    @Bindable var viewModel: HabitsViewModel

    var body: some View {

        NavigationStack {
            VStack {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(.black),
                            Color(red: 0.1, green: 0.18, blue: 0.1),
                        ],
                        startPoint: .bottom,
                        endPoint: .topTrailing
                    )
                    .ignoresSafeArea()

                    List {
                        Section {
                            if viewModel.habits.isEmpty {
                                ContentUnavailableView(
                                    "No tracked habits yet",
                                    systemImage: "xmark.circle",
                                    description: Text(
                                        "Add a tracked habit to get started!"
                                    )
                                )
                            } else {
                                ForEach(viewModel.habits) { habit in

                                    HStack {
                                        VStack(alignment: .leading, spacing: 6)
                                        {
                                            Text(habit.name)
                                                .font(.title3)
                                                .fontDesign(.rounded)
                                                .bold()
                                            Text(
                                                "Goal: \(habit.goal) \(habit.unit)"
                                            )
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .bold()
                                        }

                                        Spacer()

                                        HStack(spacing: 12) {
                                            VStack {
                                                Text("Today")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                    .bold()
                                                Spacer()
                                                Button {
                                                    Task {
                                                        await viewModel
                                                            .toggleToday(
                                                                for: habit
                                                            )
                                                    }
                                                } label: {
                                                    Image(
                                                        systemName: habit
                                                            .isCompletedToday
                                                            ? "checkmark.circle.fill"
                                                            : "circle"
                                                    )
                                                    .font(.system(size: 26))
                                                    .foregroundColor(
                                                        habit.isCompletedToday
                                                            ? .green.opacity(
                                                                0.6
                                                            )
                                                            : .gray
                                                    )
                                                }
                                                .buttonStyle(.plain)
                                            }

                                            VStack {
                                                Text("Streak")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                    .bold()
                                                Spacer()
                                                Text("🔥\(habit.currentStreak)")
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
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                showingAddHabitSheet = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddHabitSheet) {
                        AddHabitView(
                            isPresented: $showingAddHabitSheet,
                            viewModel: viewModel
                        )
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
        await viewModel.fetchHabits()
    }
}

#Preview {
    ContentView(viewModel: HabitsViewModel())
}
