//
//  ContentView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import SwiftUI

struct ContentView: View {

    @State private var habits: [Habit] = []
    
    @State private var showingAddHabitSheet = false


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
                            habits: $habits,
                            isPresented: $showingAddHabitSheet
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
        habits = await firebase.fetchHabits()
    }

}

#Preview {
    ContentView()
}
