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
