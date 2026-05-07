//
//  ContentView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import SwiftUI

struct ContentView: View {

    @State private var showingAddHabitSheet = false
    @State private var showStats = false

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
                        startPoint: .center,
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
                                        "Add a habit to get started!"
                                    )
                                )
                            } else {
                                ForEach(viewModel.habits) { habit in
                                    HabitListItemView(
                                        habit: habit,
                                        viewModel: viewModel
                                    )
                                }
                                .onDelete { offsets in
                                    Task {
                                        await viewModel.deleteHabit(at: offsets)
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                showStats = true
                            } label: {
                                Image(systemName: "chart.bar.xaxis")
                                Text("Stats")
                                    .bold()
                            }
                        }
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
            .navigationDestination(isPresented: $showStats) {
                StatsView()
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
